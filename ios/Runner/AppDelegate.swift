import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    clearTemporaryCache()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func clearTemporaryCache() {
    let fileManager = FileManager.default
    guard let contents = try? fileManager.contentsOfDirectory(
      at: fileManager.temporaryDirectory,
      includingPropertiesForKeys: nil
    ) else { return }
    for url in contents {
      try? fileManager.removeItem(at: url)
    }
  }
}
