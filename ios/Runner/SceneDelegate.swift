import Flutter
import AVFoundation
import Photos
import PhotosUI
import UIKit
import UniformTypeIdentifiers

class SceneDelegate: FlutterSceneDelegate, PHPickerViewControllerDelegate {
  private var pendingPickResult: FlutterResult?
  private var videosChannel: FlutterMethodChannel?

  override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard let controller = window?.rootViewController as? FlutterViewController else { return }

    let channel = FlutterMethodChannel(
      name: "minimo_video/thermal",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "currentState":
        result(self.currentThermalState())
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    let videosChannel = FlutterMethodChannel(
      name: "minimo_video/videos",
      binaryMessenger: controller.binaryMessenger
    )
    self.videosChannel = videosChannel
    videosChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "pickVideos":
        self.pickVideos(result)
      case "deleteOriginals":
        self.deleteOriginals(call.arguments as? [String] ?? [], result: result)
      case "videoInfo":
        self.videoInfo(call.arguments as? String, result: result)
      case "createThumbnail":
        self.createThumbnail(call.arguments as? String, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    guard let pendingPickResult else { return }

    if results.isEmpty {
      self.pendingPickResult = nil
      pendingPickResult([])
      return
    }

    print("[VideoPicker] Importing \(results.count) videos sequentially")
    videosChannel?.invokeMethod(
      "pickProgress",
      arguments: ["processed": 0, "total": results.count]
    )
    importVideos(results) { [weak self] videos in
      DispatchQueue.main.async {
        self?.pendingPickResult = nil
        print("[VideoPicker] Imported \(videos.count)/\(results.count) videos")
        pendingPickResult(videos)
      }
    }
  }

  private func importVideos(
    _ results: [PHPickerResult],
    index: Int = 0,
    videos: [[String: Any]] = [],
    completion: @escaping ([[String: Any]]) -> Void
  ) {
    guard index < results.count else {
      completion(videos)
      return
    }

    let item = results[index]
    let filename = originalFilename(for: item) ?? suggestedFilename(for: item)
    item.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) {
      [weak self] url, error in
      guard let self else {
        completion(videos)
        return
      }

      var imported = videos
      if error == nil, let url {
        do {
          let outputURL = try self.copyPickedVideo(from: url, filename: filename)
          let size = (try? FileManager.default.attributesOfItem(
            atPath: outputURL.path
          )[.size] as? NSNumber)?.intValue ?? 0
          var video: [String: Any] = [
            "path": outputURL.path,
            "name": filename,
            "size": size
          ]
          video["sourceIdentifier"] = item.assetIdentifier
          imported.append(video)
        } catch {
          print("[VideoPicker] Failed to copy video \(index + 1): \(error.localizedDescription)")
        }
      } else {
        print("[VideoPicker] Failed to load video \(index + 1): \(error?.localizedDescription ?? "unknown error")")
      }

      print("[VideoPicker] Processed \(index + 1)/\(results.count) videos")
      DispatchQueue.main.async {
        self.videosChannel?.invokeMethod(
          "pickProgress",
          arguments: ["processed": index + 1, "total": results.count]
        )
      }
      self.importVideos(
        results,
        index: index + 1,
        videos: imported,
        completion: completion
      )
    }
  }

  private func currentThermalState() -> String {
    switch ProcessInfo.processInfo.thermalState {
    case .nominal:
      return "nominal"
    case .fair:
      return "fair"
    case .serious:
      return "serious"
    case .critical:
      return "critical"
    @unknown default:
      return "unknown"
    }
  }

  private func videoInfo(_ path: String?, result: @escaping FlutterResult) {
    guard let path else {
      result(FlutterError(code: "invalid_path", message: "video path is missing", details: nil))
      return
    }
    DispatchQueue.global(qos: .userInitiated).async {
      let asset = AVURLAsset(url: URL(fileURLWithPath: path))
      let durationMs = Int((asset.duration.seconds * 1000).rounded())
      DispatchQueue.main.async { result(["durationMs": durationMs]) }
    }
  }

  private func createThumbnail(_ path: String?, result: @escaping FlutterResult) {
    guard let path else {
      result(FlutterError(code: "invalid_path", message: "video path is missing", details: nil))
      return
    }
    DispatchQueue.global(qos: .userInitiated).async {
      let asset = AVURLAsset(url: URL(fileURLWithPath: path))
      let generator = AVAssetImageGenerator(asset: asset)
      generator.appliesPreferredTrackTransform = true
      generator.maximumSize = CGSize(width: 220, height: 220)
      do {
        let image = try generator.copyCGImage(at: .zero, actualTime: nil)
        guard let data = UIImage(cgImage: image).jpegData(compressionQuality: 0.82) else {
          throw NSError(domain: "minimo_video", code: 1)
        }
        let url = FileManager.default.temporaryDirectory
          .appendingPathComponent("thumbnail_\(UUID().uuidString).jpg")
        try data.write(to: url)
        DispatchQueue.main.async { result(url.path) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "thumbnail_failed", message: error.localizedDescription, details: nil))
        }
      }
    }
  }

  private func pickVideos(_ result: @escaping FlutterResult) {
    if pendingPickResult != nil {
      result(FlutterError(
        code: "pick_in_progress",
        message: "video picker is already open",
        details: nil
      ))
      return
    }

    pendingPickResult = result
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.filter = .videos
    configuration.selectionLimit = 0
    configuration.preferredAssetRepresentationMode = .current

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    window?.rootViewController?.present(picker, animated: true)
  }

  private func deleteOriginals(_ identifiers: [String], result: @escaping FlutterResult) {
    guard !identifiers.isEmpty else {
      result(FlutterError(code: "delete_unavailable", message: "no Photos assets to delete", details: nil))
      return
    }

    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      guard status == .authorized || status == .limited else {
        result(FlutterError(code: "delete_denied", message: "Photos access was denied", details: nil))
        return
      }
      let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
      guard assets.count == identifiers.count else {
        result(FlutterError(code: "delete_unavailable", message: "some original videos are unavailable", details: nil))
        return
      }
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.deleteAssets(assets)
      }) { success, error in
        DispatchQueue.main.async {
          if success {
            result(assets.count)
          } else {
            result(FlutterError(
              code: "delete_failed",
              message: error?.localizedDescription ?? "original videos were not deleted",
              details: nil
            ))
          }
        }
      }
    }
  }

  private func originalFilename(for item: PHPickerResult) -> String? {
    guard let identifier = item.assetIdentifier else { return nil }
    let assets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
    guard let asset = assets.firstObject else { return nil }
    return PHAssetResource.assetResources(for: asset).first?.originalFilename
  }

  private func suggestedFilename(for item: PHPickerResult) -> String {
    let name = item.itemProvider.suggestedName ?? "video"
    return name.contains(".") ? name : "\(name).mov"
  }

  private func copyPickedVideo(from sourceURL: URL, filename: String) throws -> URL {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent("picked_videos", isDirectory: true)
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true
    )

    let safeFilename = sanitizeFilename(filename)
    var outputURL = directory.appendingPathComponent(safeFilename)
    let ext = outputURL.pathExtension.isEmpty ? "mov" : outputURL.pathExtension
    let baseName = outputURL.deletingPathExtension().lastPathComponent
    var index = 2

    while FileManager.default.fileExists(atPath: outputURL.path) {
      outputURL = directory.appendingPathComponent("\(baseName)_\(index).\(ext)")
      index += 1
    }

    try FileManager.default.copyItem(at: sourceURL, to: outputURL)
    return outputURL
  }

  private func sanitizeFilename(_ filename: String) -> String {
    let invalid = CharacterSet(charactersIn: #"<>:"/\|?*"#)
      .union(.controlCharacters)
    let clean = filename
      .components(separatedBy: invalid)
      .joined(separator: "_")
      .trimmingCharacters(in: .whitespacesAndNewlines)
    return clean.isEmpty ? "video.mov" : clean
  }
}
