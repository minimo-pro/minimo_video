import Flutter
import AVFoundation
import CoreLocation
import Photos
import PhotosUI
import UIKit
import UniformTypeIdentifiers

private struct PickedVideoMetadata {
  let creationDate: Date?
  let location: CLLocation?

  var isAvailable: Bool {
    creationDate != nil || location != nil
  }
}

class SceneDelegate: FlutterSceneDelegate, PHPickerViewControllerDelegate, UIDocumentPickerDelegate {
  private var pendingPickResult: FlutterResult?
  private var activePickID: UUID?
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
      case "cancelVideoPick":
        self.cancelVideoPick(result: result)
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
    guard let pendingPickResult, let pickID = activePickID else { return }

    if results.isEmpty {
      self.pendingPickResult = nil
      activePickID = nil
      pendingPickResult([])
      return
    }

    print("[VideoPicker] Importing \(results.count) videos sequentially")
    videosChannel?.invokeMethod(
      "pickProgress",
      arguments: ["processed": 0, "total": results.count]
    )
    importPhotosVideos(results, pickID: pickID) { [weak self] videos in
      DispatchQueue.main.async {
        guard self?.activePickID == pickID else { return }
        self?.pendingPickResult = nil
        self?.activePickID = nil
        print("[VideoPicker] Imported \(videos.count)/\(results.count) videos")
        pendingPickResult(videos)
      }
    }
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let pendingPickResult, let pickID = activePickID else { return }

    if urls.isEmpty {
      self.pendingPickResult = nil
      activePickID = nil
      pendingPickResult([])
      return
    }

    print("[VideoPicker] Importing \(urls.count) document videos sequentially")
    videosChannel?.invokeMethod(
      "pickProgress",
      arguments: ["processed": 0, "total": urls.count]
    )
    importDocumentVideos(urls, pickID: pickID) { [weak self] result in
      DispatchQueue.main.async {
        guard self?.activePickID == pickID else { return }
        self?.pendingPickResult = nil
        self?.activePickID = nil
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
    activePickID = nil
    pendingPickResult([])
  }

  private func importPhotosVideos(
    _ results: [PHPickerResult],
    pickID: UUID,
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
          let sourceAsset = item.assetIdentifier.flatMap {
            self.photosAssetIfAccessible(identifier: $0)
          }
          let metadata = sourceAsset.map {
            PickedVideoMetadata(
              creationDate: $0.creationDate,
              location: $0.location
            )
          } ?? self.videoMetadata(at: url)
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
            video["canDeleteOriginal"] = sourceAsset != nil
            video["canPreserveMetadata"] = sourceAsset != nil || metadata.isAvailable
          }
          if let creationDate = metadata.creationDate {
            video["captureDate"] = ISO8601DateFormatter().string(from: creationDate)
          }
          if let location = metadata.location {
            video["latitude"] = location.coordinate.latitude
            video["longitude"] = location.coordinate.longitude
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
        guard self.activePickID == pickID else { return }
        self.videosChannel?.invokeMethod(
          "pickProgress",
          arguments: ["processed": index + 1, "total": results.count]
        )
      }
      guard self.activePickID == pickID else { return }
      self.importPhotosVideos(
        results,
        pickID: pickID,
        index: index + 1,
        videos: imported,
        completion: completion
      )
    }
  }

  private func importDocumentVideos(
    _ urls: [URL],
    pickID: UUID,
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
        guard self.activePickID == pickID else { return }
        self.videosChannel?.invokeMethod(
          "pickProgress",
          arguments: ["processed": index + 1, "total": urls.count]
        )
      }
      guard self.activePickID == pickID else { return }
      self.importDocumentVideos(
        urls,
        pickID: pickID,
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
    activePickID = UUID()
    if source == "files" {
      presentDocumentPicker()
    } else {
      presentPhotosPicker()
    }
  }

  private func cancelVideoPick(result: @escaping FlutterResult) {
    let cancelledResult = pendingPickResult
    pendingPickResult = nil
    activePickID = nil
    window?.rootViewController?.presentedViewController?.dismiss(animated: true)
    cancelledResult?([])
    result(nil)
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

  private func photosAssetIfAccessible(identifier: String) -> PHAsset? {
    PHAsset.fetchAssets(
      withLocalIdentifiers: [identifier],
      options: nil
    ).firstObject
  }

  private func videoMetadata(at url: URL) -> PickedVideoMetadata {
    let asset = AVURLAsset(url: url)
    let quickTimeMetadata = asset.metadata(forFormat: .quickTimeMetadata)
    let creationItem = asset.creationDate
      ?? AVMetadataItem.metadataItems(
        from: quickTimeMetadata,
        filteredByIdentifier: .quickTimeMetadataCreationDate
      ).first
    let creationDate = creationItem?.dateValue
      ?? creationItem?.stringValue.flatMap(parseMetadataDate)
    let locationItem = AVMetadataItem.metadataItems(
      from: quickTimeMetadata,
      filteredByIdentifier: .quickTimeMetadataLocationISO6709
    ).first
    let location = locationItem?.stringValue.flatMap(parseISO6709Location)
    return PickedVideoMetadata(
      creationDate: creationDate,
      location: location
    )
  }

  private func pickedMetadata(from arguments: [String: Any]?) -> PickedVideoMetadata {
    let creationDate = (arguments?["captureDate"] as? String)
      .flatMap(parseMetadataDate)
    let latitude = (arguments?["latitude"] as? NSNumber)?.doubleValue
    let longitude = (arguments?["longitude"] as? NSNumber)?.doubleValue
    let location: CLLocation?
    if
      let latitude,
      let longitude,
      (-90...90).contains(latitude),
      (-180...180).contains(longitude)
    {
      location = CLLocation(latitude: latitude, longitude: longitude)
    } else {
      location = nil
    }
    return PickedVideoMetadata(
      creationDate: creationDate,
      location: location
    )
  }

  private func parseMetadataDate(_ value: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: value) { return date }
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: value)
  }

  private func parseISO6709Location(_ value: String) -> CLLocation? {
    let pattern = #"^([+-]\d+(?:\.\d+)?)([+-]\d+(?:\.\d+)?)"#
    guard
      let expression = try? NSRegularExpression(pattern: pattern),
      let match = expression.firstMatch(
        in: value,
        range: NSRange(value.startIndex..., in: value)
      ),
      let latitudeRange = Range(match.range(at: 1), in: value),
      let longitudeRange = Range(match.range(at: 2), in: value),
      let latitude = Double(value[latitudeRange]),
      let longitude = Double(value[longitudeRange]),
      (-90...90).contains(latitude),
      (-180...180).contains(longitude)
    else {
      return nil
    }
    return CLLocation(latitude: latitude, longitude: longitude)
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

    let fallbackMetadata = pickedMetadata(from: arguments)
    let source = photosAssetIfAccessible(identifier: sourceIdentifier)
    let accessLevel: PHAccessLevel = source == nil ? .addOnly : .readWrite
    PHPhotoLibrary.requestAuthorization(for: accessLevel) { status in
      guard status == .authorized || status == .limited else {
        DispatchQueue.main.async {
          result(FlutterError(code: "save_denied", message: "Photos access was denied", details: nil))
        }
        return
      }

      var albums: [PHAssetCollection] = []
      var skippedSourceAlbum = false
      if let source {
        let sourceAlbums = PHAssetCollection.fetchAssetCollectionsContaining(
          source,
          with: .album,
          options: nil
        )
        sourceAlbums.enumerateObjects { collection, _, _ in
          if collection.canPerform(.addContent) { albums.append(collection) }
        }
        skippedSourceAlbum = albums.count < sourceAlbums.count
      } else if !fallbackMetadata.isAvailable {
        DispatchQueue.main.async {
          result(FlutterError(code: "save_failed", message: "source metadata is unavailable", details: nil))
        }
        return
      }

      let requestedAlbum = (arguments?["album"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
      self.ensureAlbum(named: requestedAlbum) { album, albumWarning in
        if let album, !albums.contains(where: { $0.localIdentifier == album.localIdentifier }) {
          albums.append(album)
        }
        self.createReplacement(
          at: URL(fileURLWithPath: path),
          metadata: source.map {
            PickedVideoMetadata(
              creationDate: $0.creationDate,
              location: $0.location
            )
          } ?? fallbackMetadata,
          albums: albums,
          favorite: source?.isFavorite ?? false,
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
    metadata: PickedVideoMetadata,
    albums: [PHAssetCollection],
    favorite: Bool,
    initialWarnings: [String],
    result: @escaping FlutterResult
  ) {
    var identifier: String?
    PHPhotoLibrary.shared().performChanges({
      let request = PHAssetCreationRequest.forAsset()
      request.addResource(with: .video, fileURL: url, options: nil)
      request.creationDate = metadata.creationDate
      request.location = metadata.location
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

      guard favorite else {
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
