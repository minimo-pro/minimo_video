import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
  private let status = UILabel()
  private let button = UIButton(type: .system)
  private var requestReady = false
  private var openRejected = false

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    status.text = "Preparing videos…"
    status.textAlignment = .center
    button.setTitle("Open minimo", for: .normal)
    button.isEnabled = false
    button.addTarget(self, action: #selector(openApp), for: .touchUpInside)
    let stack = UIStackView(arrangedSubviews: [status, button])
    stack.axis = .vertical; stack.spacing = 18
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    NSLayoutConstraint.activate([stack.centerXAnchor.constraint(equalTo: view.centerXAnchor), stack.centerYAnchor.constraint(equalTo: view.centerYAnchor), stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24)])
    loadAttachments()
  }

  private func loadAttachments() {
    let providers = extensionContext?.inputItems.compactMap { $0 as? NSExtensionItem }.flatMap { $0.attachments ?? [] }.filter { $0.hasItemConformingToTypeIdentifier(UTType.movie.identifier) } ?? []
    guard !providers.isEmpty, providers.count <= SharedVideoInbox.maximumVideos else { return fail("Select 1–20 videos") }
    let group = DispatchGroup(); let lock = NSLock(); var urls: [URL] = []; var failed = false
    for provider in providers {
      group.enter()
      provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
        defer { group.leave() }
        guard let url, error == nil else { failed = true; return }
        let temporary = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + "-" + url.lastPathComponent)
        do { try FileManager.default.copyItem(at: url, to: temporary); lock.lock(); urls.append(temporary); lock.unlock() } catch { failed = true }
      }
    }
    group.notify(queue: .global(qos: .userInitiated)) {
      guard !failed else { return DispatchQueue.main.async { self.fail("Couldn’t import videos") } }
      do { _ = try SharedVideoInbox.stage(urls: urls, source: "share", preset: "medium"); DispatchQueue.main.async { self.status.text = "Ready"; self.button.isEnabled = true; self.requestReady = true } }
      catch { DispatchQueue.main.async { self.fail(error.localizedDescription) } }
      urls.forEach { try? FileManager.default.removeItem(at: $0) }
    }
  }

  private func fail(_ message: String) { status.text = message; button.isEnabled = false }

  @objc private func openApp() {
    if openRejected {
      extensionContext?.completeRequest(returningItems: nil)
      return
    }
    guard requestReady, let url = URL(string: "minimovideo://external-import") else { return }
    button.isEnabled = false
    extensionContext?.open(url) { opened in
      DispatchQueue.main.async {
        if opened {
          self.extensionContext?.completeRequest(returningItems: nil)
        } else {
          self.openRejected = true
          self.status.text = "Ready — open minimo manually"
          self.button.setTitle("Done", for: .normal)
          self.button.isEnabled = true
        }
      }
    }
  }
}
