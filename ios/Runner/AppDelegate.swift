import Flutter
import Photos
import PhotosUI
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, PHPickerViewControllerDelegate {
  private var pendingPickResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller = window?.rootViewController as! FlutterViewController
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
    videosChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "pickVideos":
        self.pickVideos(result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    guard let pendingPickResult else { return }
    self.pendingPickResult = nil

    if results.isEmpty {
      pendingPickResult([])
      return
    }

    let group = DispatchGroup()
    var videos = Array<Any?>(repeating: nil, count: results.count)

    for (index, item) in results.enumerated() {
      group.enter()
      let filename = originalFilename(for: item) ?? suggestedFilename(for: item)
      item.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
        defer { group.leave() }
        guard error == nil, let url else { return }

        do {
          let outputURL = try self.copyPickedVideo(from: url, filename: filename)
          let size = (try? FileManager.default.attributesOfItem(
            atPath: outputURL.path
          )[.size] as? NSNumber)?.intValue ?? 0
          videos[index] = [
            "path": outputURL.path,
            "name": filename,
            "size": size
          ]
        } catch {
          videos[index] = nil
        }
      }
    }

    group.notify(queue: .main) {
      pendingPickResult(videos.compactMap { $0 })
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
