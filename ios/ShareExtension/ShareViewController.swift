import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
  private let accent = UIColor(red: 252 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1)
  private let iconView = UIImageView(image: UIImage(systemName: "video.fill"))
  private let status = UILabel()
  private let detail = UILabel()
  private let progress = UIProgressView(progressViewStyle: .default)
  private let button = UIButton(type: .system)

  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
    loadAttachments()
  }

  private func buildUI() {
    view.backgroundColor = UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 18 / 255, green: 18 / 255, blue: 18 / 255, alpha: 1) : UIColor(red: 241 / 255, green: 242 / 255, blue: 246 / 255, alpha: 1) }

    iconView.tintColor = .white
    iconView.contentMode = .center
    iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28, weight: .semibold)
    iconView.backgroundColor = accent
    iconView.layer.cornerRadius = 18
    iconView.translatesAutoresizingMaskIntoConstraints = false

    let title = UILabel()
    title.text = "minimo"
    title.font = .systemFont(ofSize: 28, weight: .bold)
    title.textAlignment = .center

    let subtitle = UILabel()
    subtitle.text = "Private video compression"
    subtitle.font = .systemFont(ofSize: 14, weight: .medium)
    subtitle.textColor = .secondaryLabel
    subtitle.textAlignment = .center

    status.text = "Preparing videos…"
    status.font = .systemFont(ofSize: 20, weight: .semibold)
    status.textAlignment = .center

    detail.text = "Copying securely to minimo"
    detail.font = .systemFont(ofSize: 14)
    detail.textColor = .secondaryLabel
    detail.textAlignment = .center
    detail.numberOfLines = 2

    progress.progressTintColor = accent
    progress.trackTintColor = accent.withAlphaComponent(0.14)
    progress.layer.cornerRadius = 2
    progress.clipsToBounds = true
    progress.setProgress(0.08, animated: false)

    var configuration = UIButton.Configuration.filled()
    configuration.title = "Done"
    configuration.baseBackgroundColor = accent
    configuration.baseForegroundColor = .white
    configuration.cornerStyle = .large
    configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
    button.configuration = configuration
    button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    button.isEnabled = false
    button.addTarget(self, action: #selector(closeExtension), for: .touchUpInside)

    let card = UIView()
    card.backgroundColor = .secondarySystemBackground
    card.layer.cornerRadius = 24
    card.translatesAutoresizingMaskIntoConstraints = false

    let content = UIStackView(arrangedSubviews: [status, detail, progress, button])
    content.axis = .vertical
    content.spacing = 16
    content.setCustomSpacing(8, after: status)
    content.translatesAutoresizingMaskIntoConstraints = false
    card.addSubview(content)

    let header = UIStackView(arrangedSubviews: [iconView, title, subtitle])
    header.axis = .vertical
    header.alignment = .center
    header.spacing = 8

    let layout = UIStackView(arrangedSubviews: [header, card])
    layout.axis = .vertical
    layout.spacing = 28
    layout.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(layout)

    NSLayoutConstraint.activate([
      iconView.widthAnchor.constraint(equalToConstant: 64),
      iconView.heightAnchor.constraint(equalToConstant: 64),
      layout.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      layout.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      layout.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      content.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
      content.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
      content.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
      content.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
    ])
  }

  private func loadAttachments() {
    let providers = extensionContext?.inputItems
      .compactMap { $0 as? NSExtensionItem }
      .flatMap { $0.attachments ?? [] }
      .filter { $0.hasItemConformingToTypeIdentifier(UTType.movie.identifier) } ?? []
    guard !providers.isEmpty, providers.count <= SharedVideoInbox.maximumVideos else {
      return fail("Select 1–20 videos")
    }

    detail.text = providers.count == 1 ? "Preparing 1 video" : "Preparing \(providers.count) videos"
    let group = DispatchGroup()
    let lock = NSLock()
    var copied: [(Int, URL)] = []
    var failed = false
    var processed = 0

    for (index, provider) in providers.enumerated() {
      group.enter()
      provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
        defer { group.leave() }
        var output: URL?
        if let url, error == nil {
          let temporary = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + "-" + url.lastPathComponent)
          do {
            try FileManager.default.copyItem(at: url, to: temporary)
            output = temporary
          } catch {}
        }

        lock.lock()
        if let output { copied.append((index, output)) } else { failed = true }
        processed += 1
        let value = Float(processed) / Float(providers.count)
        lock.unlock()
        DispatchQueue.main.async { self?.progress.setProgress(0.08 + value * 0.72, animated: true) }
      }
    }

    group.notify(queue: .global(qos: .userInitiated)) { [weak self] in
      let urls = copied.sorted { $0.0 < $1.0 }.map(\.1)
      defer { urls.forEach { try? FileManager.default.removeItem(at: $0) } }
      guard !failed else { return DispatchQueue.main.async { self?.fail("Couldn’t import videos") } }
      do {
        _ = try SharedVideoInbox.stage(urls: urls, source: "share", preset: "medium")
        DispatchQueue.main.async { self?.showReady(videoCount: urls.count) }
      } catch {
        DispatchQueue.main.async { self?.fail(error.localizedDescription) }
      }
    }
  }

  private func showReady(videoCount: Int) {
    status.text = videoCount == 1 ? "Video is ready" : "Videos are ready"
    detail.text = "Open minimo from your Home Screen to continue"
    progress.setProgress(1, animated: true)
    button.isEnabled = true
    UIView.transition(with: iconView, duration: 0.35, options: .transitionFlipFromLeft) {
      self.iconView.image = UIImage(systemName: "checkmark")
    }
  }

  private func fail(_ message: String) {
    status.text = "Import failed"
    detail.text = message
    progress.isHidden = true
    iconView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    button.isEnabled = true
  }

  @objc private func closeExtension() {
    extensionContext?.completeRequest(returningItems: nil)
  }
}
