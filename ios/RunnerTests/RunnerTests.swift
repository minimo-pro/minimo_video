import Flutter
import UIKit
import XCTest
import BackgroundTasks
@testable import Runner

class RunnerTests: XCTestCase {

  func testBackgroundRequestUsesConcreteIDsAndOptionalGPU() throws {
    guard #available(iOS 26.0, *) else { throw XCTSkip("Requires iOS 26") }
    let background = BackgroundCompression.shared
    let cpuRequest = background.makeRequest(token: "first", gpuSupported: false)
    let gpuRequest = background.makeRequest(token: "second", gpuSupported: true)
    let prefix = try XCTUnwrap(Bundle.main.bundleIdentifier) + ".compression."

    XCTAssertEqual(cpuRequest.identifier, prefix + "first")
    XCTAssertEqual(gpuRequest.identifier, prefix + "second")
    XCTAssertFalse(cpuRequest.identifier.contains("*"))
    XCTAssertFalse(cpuRequest.requiredResources.contains(.gpu))
    XCTAssertTrue(gpuRequest.requiredResources.contains(.gpu))
    XCTAssertEqual(cpuRequest.strategy, .fail)
    let permitted = try XCTUnwrap(Bundle.main.object(
      forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") as? [String])
    XCTAssertTrue(permitted.contains(prefix + "*"))
  }

  func testInboxPublishesManifestAfterFiles() throws {
    let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    let source = root.appendingPathComponent("source.mov")
    try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
    try Data([1, 2, 3]).write(to: source)
    defer { try? FileManager.default.removeItem(at: root) }

    _ = try SharedVideoInbox.stage(urls: [source], source: "test", preset: "high", root: root)
    let (request, directory) = try XCTUnwrap(SharedVideoInbox.next(root: root))

    XCTAssertEqual(request.preset, "high")
    XCTAssertTrue(FileManager.default.fileExists(atPath: directory.appendingPathComponent("manifest.json").path))
    XCTAssertTrue(FileManager.default.fileExists(atPath: directory.appendingPathComponent(request.files[0]).path))
  }

}
