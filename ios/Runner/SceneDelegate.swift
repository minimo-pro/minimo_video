import Flutter
import AVFoundation
import CoreLocation
import Photos
import PhotosUI
import UIKit
import UniformTypeIdentifiers

class SceneDelegate: FlutterSceneDelegate, PHPickerViewControllerDelegate, UIDocumentPickerDelegate {
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
        let source = (call.arguments as? [String: Any])?["source"] as? String ?? "gallery"
        self.pickVideos(source: source, result: result)
      case "deleteOriginals":
        self.deleteOriginals(call.arguments as? [String] ?? [], result: result)
      case "saveReplacement":
        self.saveReplacement(call.arguments as? [String: Any], result: result)
      case "videoInfo":
        self.videoInfo(call.arguments as? String, result: result)
      case "createThumbnail":
        self.createThumbnail(call.arguments as? String, result: result)
      case "temporaryCacheSize":
        self.temporaryCacheSize(result: result)
      case "clearTemporaryCache":
        self.clearTemporaryCache(result: result)
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
    importPhotosVideos(results) { [weak self] videos in
      DispatchQueue.main.async {
        self?.pendingPickResult = nil
        print("[VideoPicker] Imported \(videos.count)/\(results.count) videos")
        pendingPickResult(videos)
      }
    }
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let pendingPickResult else { return }

    if urls.isEmpty {
      self.pendingPickResult = nil
      pendingPickResult([])
      return
    }

    print("[VideoPicker] Importing \(urls.count) document videos sequentially")
    videosChannel?.invokeMethod(
      "pickProgress",
      arguments: ["processed": 0, "total": urls.count]
    )
    importDocumentVideos(urls) { [weak self] result in
      DispatchQueue.main.async {
        self?.pendingPickResult = nil
        switch result {
        case .success(let videos):
          print("[VideoPicker] Imported \(videos.count)/\(urls.count) videos")
          pendingPickResult(videos)
        case .failure(let error):
          pendingPickResult(FlutterError(
            code: "pick_failed",
            message: error.localizedDescription,
            details: nil
          ))
        }
      }
    }
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    guard let pendingPickResult else { return }
    self.pendingPickResult = nil
    pendingPickResult([])
  }

  private func importPhotosVideos(
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
          if let assetIdentifier = item.assetIdentifier {
            video["sourceIdentifier"] = assetIdentifier
            video["canDeleteOriginal"] = true
          }
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
      self.importPhotosVideos(
        results,
        index: index + 1,
        videos: imported,
        completion: completion
      )
    }
  }

  private func importDocumentVideos(
    _ urls: [URL],
    index: Int = 0,
    videos: [[String: Any]] = [],
    completion: @escaping (Result<[[String: Any]], Error>) -> Void
  ) {
    guard index < urls.count else {
      completion(.success(videos))
      return
    }

    let url = urls[index]
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self else {
        completion(.failure(NSError(
          domain: "VideoPicker",
          code: 2,
          userInfo: [NSLocalizedDescriptionKey: "video picker is unavailable"]
        )))
        return
      }

      var imported = videos
      do {
        let filename = url.lastPathComponent.isEmpty ? "video.mov" : url.lastPathComponent
        let outputURL = try self.copyPickedVideo(from: url, filename: filename)
        let size = (try? FileManager.default.attributesOfItem(
          atPath: outputURL.path
        )[.size] as? NSNumber)?.intValue ?? 0
        imported.append([
          "path": outputURL.path,
          "name": filename,
          "size": size
        ])
      } catch {
        print("[VideoPicker] Failed to copy document video \(index + 1): \(error.localizedDescription)")
        completion(.failure(error))
        return
      }

      print("[VideoPicker] Processed \(index + 1)/\(urls.count) videos")
      DispatchQueue.main.async {
        self.videosChannel?.invokeMethod(
          "pickProgress",
          arguments: ["processed": index + 1, "total": urls.count]
        )
      }
      self.importDocumentVideos(
        urls,
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
        let directory = try self.cacheDirectory(named: "minimo_thumbnails")
        let url = directory.appendingPathComponent(
          "thumbnail_\(UUID().uuidString).jpg"
        )
        try data.write(to: url)
        DispatchQueue.main.async { result(url.path) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "thumbnail_failed", message: error.localizedDescription, details: nil))
        }
      }
    }
  }

  private func pickVideos(source: String, result: @escaping FlutterResult) {
    if pendingPickResult != nil {
      result(FlutterError(
        code: "pick_in_progress",
        message: "video picker is already open",
        details: nil
      ))
      return
    }

    pendingPickResult = result
    if source == "files" {
      presentDocumentPicker()
    } else {
      presentPhotosPicker()
    }
  }

  private func presentPhotosPicker() {
    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.filter = .videos
    configuration.selectionLimit = 0
    configuration.preferredAssetRepresentationMode = .current

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    window?.rootViewController?.present(picker, animated: true)
  }

  private func presentDocumentPicker() {
    let picker = UIDocumentPickerViewController(
      forOpeningContentTypes: [.movie],
      asCopy: true
    )
    picker.allowsMultipleSelection = true
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

  private func saveReplacement(
    _ arguments: [String: Any]?,
    result: @escaping FlutterResult
  ) {
    guard
      let path = arguments?["path"] as? String,
      let sourceIdentifier = arguments?["sourceIdentifier"] as? String,
      FileManager.default.fileExists(atPath: path)
    else {
      result(FlutterError(code: "save_failed", message: "replacement video is unavailable", details: nil))
      return
    }

    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      guard status == .authorized || status == .limited else {
        DispatchQueue.main.async {
          result(FlutterError(code: "save_denied", message: "Photos access was denied", details: nil))
        }
        return
      }

      let assets = PHAsset.fetchAssets(withLocalIdentifiers: [sourceIdentifier], options: nil)
      guard let source = assets.firstObject else {
        DispatchQueue.main.async {
          result(FlutterError(code: "save_failed", message: "original Photos asset is unavailable", details: nil))
        }
        return
      }

      let sourceAlbums = PHAssetCollection.fetchAssetCollectionsContaining(
        source,
        with: .album,
        options: nil
      )
      var albums: [PHAssetCollection] = []
      sourceAlbums.enumerateObjects { collection, _, _ in
        if collection.canPerform(.addContent) { albums.append(collection) }
      }
      let skippedSourceAlbum = albums.count < sourceAlbums.count

      let requestedAlbum = (arguments?["album"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
      self.ensureAlbum(named: requestedAlbum) { album, albumWarning in
        if let album, !albums.contains(where: { $0.localIdentifier == album.localIdentifier }) {
          albums.append(album)
        }
        self.createReplacement(
          at: URL(fileURLWithPath: path),
          source: source,
          albums: albums,
          initialWarnings: albumWarning || skippedSourceAlbum ? ["album_unavailable"] : [],
          result: result
        )
      }
    }
  }

  private func ensureAlbum(
    named name: String?,
    completion: @escaping (PHAssetCollection?, Bool) -> Void
  ) {
    guard let name, !name.isEmpty else {
      completion(nil, false)
      return
    }
    let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
    var existing: PHAssetCollection?
    collections.enumerateObjects { collection, _, stop in
      if collection.localizedTitle == name {
        existing = collection
        stop.pointee = true
      }
    }
    if let existing {
      completion(existing, false)
      return
    }

    var identifier: String?
    PHPhotoLibrary.shared().performChanges({
      identifier = PHAssetCollectionChangeRequest
        .creationRequestForAssetCollection(withTitle: name)
        .placeholderForCreatedAssetCollection
        .localIdentifier
    }) { success, _ in
      guard success, let identifier else {
        completion(nil, true)
        return
      }
      completion(
        PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: nil).firstObject,
        false
      )
    }
  }

  private func createReplacement(
    at url: URL,
    source: PHAsset,
    albums: [PHAssetCollection],
    initialWarnings: [String],
    result: @escaping FlutterResult
  ) {
    var identifier: String?
    PHPhotoLibrary.shared().performChanges({
      let request = PHAssetCreationRequest.forAsset()
      request.addResource(with: .video, fileURL: url, options: nil)
      request.creationDate = source.creationDate
      request.location = source.location
      let placeholder = request.placeholderForCreatedAsset
      identifier = placeholder?.localIdentifier
      if let placeholder {
        for album in albums {
          PHAssetCollectionChangeRequest(for: album)?.addAssets([placeholder] as NSArray)
        }
      }
    }) { success, error in
      guard success, let identifier else {
        DispatchQueue.main.async {
          result(FlutterError(
            code: "save_failed",
            message: error?.localizedDescription ?? "replacement video was not saved",
            details: nil
          ))
        }
        return
      }

      let created = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
      guard let replacement = created.firstObject else {
        DispatchQueue.main.async {
          result(FlutterError(code: "save_failed", message: "replacement video could not be verified", details: nil))
        }
        return
      }

      guard source.isFavorite else {
        DispatchQueue.main.async { result(["saved": true, "warnings": initialWarnings]) }
        return
      }
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest(for: replacement).isFavorite = true
      }) { favoriteSaved, _ in
        var warnings = initialWarnings
        if !favoriteSaved { warnings.append("favorite_unavailable") }
        DispatchQueue.main.async { result(["saved": true, "warnings": warnings]) }
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
    let directory = try cacheDirectory(named: "picked_videos")

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
    guard isVideoFile(outputURL) else {
      try? FileManager.default.removeItem(at: outputURL)
      throw NSError(
        domain: "VideoPicker",
        code: 1,
        userInfo: [NSLocalizedDescriptionKey: "selected file is not a video"]
      )
    }
    return outputURL
  }

  private func cacheDirectory(named name: String) throws -> URL {
    guard let cacheRoot = FileManager.default.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    ).first else {
      throw NSError(
        domain: "minimo_video",
        code: 2,
        userInfo: [NSLocalizedDescriptionKey: "cache directory is unavailable"]
      )
    }
    let directory = cacheRoot.appendingPathComponent(name, isDirectory: true)
    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true
    )
    return directory
  }

  private func temporaryCacheSize(result: @escaping FlutterResult) {
    DispatchQueue.global(qos: .utility).async {
      let root = FileManager.default.temporaryDirectory
      let keys: [URLResourceKey] = [.isRegularFileKey, .fileSizeKey]
      let enumerator = FileManager.default.enumerator(
        at: root,
        includingPropertiesForKeys: keys
      )
      var bytes = 0
      while let url = enumerator?.nextObject() as? URL {
        guard
          let values = try? url.resourceValues(forKeys: Set(keys)),
          values.isRegularFile == true
        else { continue }
        bytes += values.fileSize ?? 0
      }
      DispatchQueue.main.async { result(bytes) }
    }
  }

  private func clearTemporaryCache(result: @escaping FlutterResult) {
    DispatchQueue.global(qos: .utility).async {
      do {
        let root = FileManager.default.temporaryDirectory
        for url in try FileManager.default.contentsOfDirectory(
          at: root,
          includingPropertiesForKeys: nil
        ) {
          try FileManager.default.removeItem(at: url)
        }
        DispatchQueue.main.async { result(nil) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(
            code: "cache_clear_failed",
            message: error.localizedDescription,
            details: nil
          ))
        }
      }
    }
  }

  private func isVideoFile(_ url: URL) -> Bool {
    !AVURLAsset(url: url).tracks(withMediaType: .video).isEmpty
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
