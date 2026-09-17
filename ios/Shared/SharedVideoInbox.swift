import Foundation

struct ExternalVideoRequest: Codable {
  let id: String
  let source: String
  let preset: String
  let files: [String]
}

enum SharedVideoInbox {
  static let groupIdentifier = "group.com.khlebobul.minimoVideo"
  static let maximumVideos = 20

  static func stage(urls: [URL], source: String, preset: String, root: URL? = nil) throws -> String {
    guard !urls.isEmpty, urls.count <= maximumVideos else {
      throw NSError(domain: "SharedVideoInbox", code: 1, userInfo: [NSLocalizedDescriptionKey: "select 1–20 videos"])
    }
    let root = try inboxURL(root)
    let id = UUID().uuidString
    let staging = root.appendingPathComponent(".\(id)", isDirectory: true)
    let published = root.appendingPathComponent(id, isDirectory: true)
    try FileManager.default.createDirectory(at: staging, withIntermediateDirectories: true)
    do {
      var names: [String] = []
      for (index, url) in urls.enumerated() {
        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
        let name = "\(index)-\(sanitize(url.lastPathComponent))"
        try FileManager.default.copyItem(at: url, to: staging.appendingPathComponent(name))
        names.append(name)
      }
      let safePreset = ["high", "medium", "low"].contains(preset) ? preset : "medium"
      let request = ExternalVideoRequest(id: id, source: source, preset: safePreset, files: names)
      let data = try JSONEncoder().encode(request)
      try data.write(to: staging.appendingPathComponent("manifest.json"), options: .atomic)
      try FileManager.default.moveItem(at: staging, to: published)
      return id
    } catch {
      try? FileManager.default.removeItem(at: staging)
      throw error
    }
  }

  static func next(root: URL? = nil) throws -> (ExternalVideoRequest, URL)? {
    let root = try inboxURL(root)
    for directory in try FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil)
      .filter({ !$0.lastPathComponent.hasPrefix(".") }).sorted(by: { $0.lastPathComponent < $1.lastPathComponent }) {
      let manifest = directory.appendingPathComponent("manifest.json")
      guard let data = try? Data(contentsOf: manifest),
            let request = try? JSONDecoder().decode(ExternalVideoRequest.self, from: data),
            request.id == directory.lastPathComponent,
            !request.files.isEmpty,
            request.files.count <= maximumVideos,
            Set(request.files).count == request.files.count,
            request.files.allSatisfy({ URL(fileURLWithPath: $0).lastPathComponent == $0 }),
            request.files.allSatisfy({ FileManager.default.fileExists(atPath: directory.appendingPathComponent($0).path) })
      else {
        try? FileManager.default.removeItem(at: directory)
        continue
      }
      return (request, directory)
    }
    return nil
  }

  static func remove(_ directory: URL) { try? FileManager.default.removeItem(at: directory) }

  private static func inboxURL(_ explicitRoot: URL?) throws -> URL {
    if let explicitRoot {
      try FileManager.default.createDirectory(at: explicitRoot, withIntermediateDirectories: true)
      return explicitRoot
    }
    guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
      throw NSError(domain: "SharedVideoInbox", code: 2, userInfo: [NSLocalizedDescriptionKey: "App Group is unavailable"])
    }
    let inbox = container.appendingPathComponent("inbox", isDirectory: true)
    try FileManager.default.createDirectory(at: inbox, withIntermediateDirectories: true)
    for item in (try? FileManager.default.contentsOfDirectory(at: inbox, includingPropertiesForKeys: [.contentModificationDateKey])) ?? [] where item.lastPathComponent.hasPrefix(".") {
      if let date = try? item.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate,
         Date().timeIntervalSince(date) > 3600 { try? FileManager.default.removeItem(at: item) }
    }
    return inbox
  }

  private static func sanitize(_ name: String) -> String {
    let invalid = CharacterSet(charactersIn: #"<>:"/\|?*"#).union(.controlCharacters)
    let clean = name.components(separatedBy: invalid).joined(separator: "_").trimmingCharacters(in: .whitespacesAndNewlines)
    return clean.isEmpty ? "video.mov" : clean
  }
}
