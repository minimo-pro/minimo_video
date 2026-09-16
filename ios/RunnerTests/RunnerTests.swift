import Flutter
import UIKit
import XCTest
@testable import Runner

class RunnerTests: XCTestCase {

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
