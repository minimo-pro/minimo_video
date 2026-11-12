import Flutter
import UIKit
import BackgroundTasks

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

// One task covers the whole sequential batch, including Dart file finalization.
@available(iOS 26.0, *)
final class BackgroundCompression {
  static let shared = BackgroundCompression()
  private let identifier = Bundle.main.bundleIdentifier! + ".compression"
  private var task: BGContinuedProcessingTask?
  private var token: String?
  private var pendingResult: FlutterResult?
  var channel: FlutterMethodChannel?

  private func register(_ request: BGContinuedProcessingTaskRequest) -> Bool {
    // Wildcards belong in Info.plist; register the concrete ID of each request.
    return BGTaskScheduler.shared.register(
      forTaskWithIdentifier: request.identifier, using: .main
    ) { [weak self] task in
      guard let self, let task = task as? BGContinuedProcessingTask else { return }
      NSLog("[DEBUG-bg27] Launch callback: %@", task.identifier)
      guard let token = self.token, task.identifier == self.identifier + "." + token,
            let result = self.pendingResult else {
        task.setTaskCompleted(success: false)
        return
      }
      self.task = task
      self.pendingResult = nil
      task.progress.totalUnitCount = 1000
      task.expirationHandler = { [weak self] in
        DispatchQueue.main.async {
          guard let self, self.task === task, let token = self.token else { return }
          NSLog("[DEBUG-bg27] Task expired or cancelled by system UI")
          self.channel?.invokeMethod("cancel", arguments: token)
          self.finish(success: false)
        }
      }
      NSLog("[DEBUG-bg27] Runtime granted")
      result(true)
    }
  }

  func start(token: String, result: @escaping FlutterResult) {
    let gpuSupported = BGTaskScheduler.supportedResources.contains(.gpu)
    let appState = UIApplication.shared.applicationState
    NSLog("[DEBUG-bg27] Start: OS=%@ gpu=%@ state=%ld",
          UIDevice.current.systemVersion, String(gpuSupported), appState.rawValue)
    guard appState == .active else {
      NSLog("[DEBUG-bg27] Rejected: app is not active")
      result(FlutterError(code: "background_app_inactive", message: "App must be active when submitting the background task",
                          details: ["iosVersion": UIDevice.current.systemVersion,
                                    "gpuSupported": gpuSupported, "appState": appState.rawValue]))
      return
    }
    finish(success: false)
    self.token = token
    pendingResult = result
    let request = makeRequest(token: token, gpuSupported: gpuSupported)
    guard register(request) else {
      rejectPending(FlutterError(code: "background_registration_failed",
        message: "Background task handler registration failed",
        details: ["identifier": request.identifier,
                  "permittedIdentifiers": Bundle.main.object(forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") ?? [],
                  "iosVersion": UIDevice.current.systemVersion, "gpuSupported": gpuSupported]))
      return
    }
    do {
      try BGTaskScheduler.shared.submit(request)
      NSLog("[DEBUG-bg27] Request submitted: %@", request.identifier)
      // Do not hold the Compress button forever if the launch callback never arrives.
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
        guard let self, self.token == token, self.pendingResult != nil else { return }
        NSLog("[DEBUG-bg27] Rejected: no launch callback within 3 seconds")
        self.rejectPending(FlutterError(code: "background_launch_timeout",
          message: "Scheduler did not launch the submitted task within 3 seconds", details: nil))
      }
    } catch {
      let failure = error as NSError
      NSLog("[DEBUG-bg27] Submission failed: domain=%@ code=%ld description=%@",
            failure.domain, failure.code, failure.localizedDescription)
      rejectPending(FlutterError(code: "background_submission_failed",
        message: failure.localizedDescription,
        details: ["domain": failure.domain, "code": failure.code]))
    }
  }

  func makeRequest(token: String, gpuSupported: Bool) -> BGContinuedProcessingTaskRequest {
    let request = BGContinuedProcessingTaskRequest(
      identifier: identifier + "." + token, title: "minimo", subtitle: "0%"
    )
    request.strategy = .fail
    // The normal reader/writer path can run without a background GPU grant.
    if gpuSupported { request.requiredResources = .gpu }
    return request
  }

  private func rejectPending(_ error: FlutterError) {
    let pending = pendingResult
    pendingResult = nil
    finish(success: false)
    pending?(error)
  }

  func update(token: String, progress: Double, index: Int, count: Int) {
    guard self.token == token, let task, progress.isFinite else { return }
    // Reserve 100% for the completion of file moves and the batch loop.
    task.progress.completedUnitCount = Int64(min(999, max(0, progress * 1000)))
    task.updateTitle(task.title, subtitle: "\(index) / \(count) · \(Int(progress * 100))%")
  }

  func finish(success: Bool) {
    if let token {
      BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier + "." + token)
    }
    let pending = pendingResult
    pendingResult = nil
    token = nil
    if let task {
      task.expirationHandler = nil
      if success { task.progress.completedUnitCount = task.progress.totalUnitCount }
      task.setTaskCompleted(success: success)
    }
    task = nil
    pending?(false)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    guard let token = args["token"] as? String else {
      result(FlutterError(code: "invalid_args", message: "Missing task token", details: nil))
      return
    }
    switch call.method {
    case "start": start(token: token, result: result)
    case "update":
      if let progress = args["progress"] as? Double,
         let index = args["index"] as? Int, let count = args["count"] as? Int {
        update(token: token, progress: progress, index: index, count: count)
      }
      result(nil)
    case "finish":
      if self.token == token { finish(success: args["success"] as? Bool ?? false) }
      result(nil)
    default: result(FlutterMethodNotImplemented)
    }
  }
}
