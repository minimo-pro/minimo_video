import AppIntents
import UniformTypeIdentifiers

@available(iOS 16.0, *)
enum ShortcutCompressionPreset: String, AppEnum {
  case high, medium, low
  static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Quality")
  static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
    .high: "High", .medium: "Medium", .low: "Low"
  ]
}

@available(iOS 16.0, *)
struct CompressVideosIntent: AppIntent {
  static let title: LocalizedStringResource = "Compress Videos in minimo"
  static let description = IntentDescription("Open selected videos in minimo for compression.")
  static let openAppWhenRun = true

  @Parameter(title: "Videos")
  var videos: [IntentFile]

  @Parameter(title: "Quality", default: .medium)
  var preset: ShortcutCompressionPreset

  func perform() async throws -> some IntentResult {
    let urls = videos.compactMap(\.fileURL)
    _ = try SharedVideoInbox.stage(urls: urls, source: "shortcut", preset: preset.rawValue)
    return .result()
  }
}

@available(iOS 16.0, *)
struct MinimoShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: CompressVideosIntent(),
      phrases: ["Compress videos in \(.applicationName)"],
      shortTitle: "Compress Videos",
      systemImageName: "video.badge.minus"
    )
  }
}
