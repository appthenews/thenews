import AppKit
import Combine
import StoreKit
import News

final class Sponsor: NSWindow {
    private weak var purchase: Control.Prominent!
    private weak var disclaimer: Text!
    private weak var received: Text!
    private weak var restore: Control.Plain!
    private var product: Product?
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    init(session: Session) {
        self.session = session
        
        super.init(contentRect: .init(x: 0, y: 0, width: 440, height: 540),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .hudWindow
        contentView = content
        center()
        
        let image = NSImageView(image: .init(systemSymbolName: "arrow.up.heart", accessibilityDescription: nil) ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.symbolConfiguration = .init(pointSize: 100, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .controlAccentColor))
        image.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(image)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        var string = NSMutableAttributedString()
        string.append(.init(string: "Fund The News App",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize,
                                                         weight: .medium),
                                .foregroundColor: NSColor.labelColor,
                                .paragraphStyle: paragraph]))
        string.append(.init(string: "\n\n", attributes: [.font: NSFont.systemFont(ofSize: 5)]))
        string.append(.init(string: "Contributes to maintenance and\nmaking it available for everyone.",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize,
                                                         weight: .regular),
                                .foregroundColor: NSColor.secondaryLabelColor,
                                .paragraphStyle: paragraph]))
        
        let title = Text(vibrancy: true)
        title.attributedStringValue = string
        content.addSubview(title)
                           
        let purchase = Control.Prominent(title: "Sponsor")
        purchase
            .click
            .sink { [weak self] in
                Task { [weak self] in
                    await self?.pay()
                }
            }
            .store(in: &subs)
        content.addSubview(purchase)
        purchase.state = .hidden
        self.purchase = purchase
        
        let disclaimer = Text(vibrancy: true)
        disclaimer.font = .preferredFont(forTextStyle: .body)
        disclaimer.stringValue = "1 time purchase"
        disclaimer.textColor = .secondaryLabelColor
        disclaimer.isHidden = true
        content.addSubview(disclaimer)
        self.disclaimer = disclaimer
        
        string = NSMutableAttributedString()
        string.append(.init(string: "Thank you",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize,
                                                         weight: .regular),
                                .foregroundColor: NSColor.labelColor,
                                .paragraphStyle: paragraph]))
        string.append(.init(string: "\n\n", attributes: [.font: NSFont.systemFont(ofSize: 4)]))
        string.append(.init(string: "We received\nyour contribution.",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize,
                                                         weight: .light),
                                .foregroundColor: NSColor.secondaryLabelColor,
                                .paragraphStyle: paragraph]))
        
        let received = Text(vibrancy: true)
        received.attributedStringValue = string
        received.isHidden = true
        content.addSubview(received)
        self.received = received
        
        let restore = Control.Plain(title: "Restore Purchases")
        restore.state = .hidden
        restore
            .click
            .sink {
                Task {
                    await session.store.restore()
                }
            }
            .store(in: &subs)
        content.addSubview(restore)
        self.restore = restore
        
        let cancel = Control.Plain(title: "Cancel")
        cancel
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        content.addSubview(cancel)
        
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 70).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 50).isActive = true
        title.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
        
        purchase.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        purchase.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        purchase.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        disclaimer.topAnchor.constraint(equalTo: purchase.bottomAnchor, constant: 20).isActive = true
        disclaimer.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        received.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 50).isActive = true
        received.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        restore.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -1).isActive = true
        restore.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        restore.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        cancel.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -40).isActive = true
        cancel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 190).isActive = true

        session
            .store
            .status
            .sink { [weak self] in
                switch $0 {
                case .ready:
                    Task { [weak self] in
                        await self?.refresh()
                    }
                case let .error(error):
                    let alert = NSAlert()
                    alert.alertStyle = .warning
                    alert.icon = .init(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
                    alert.messageText = "Sponsor"
                    alert.informativeText = error
                    
                    let cont = alert.addButton(withTitle: "OK")
                    cont.keyEquivalent = "\r"
                    alert.runModal()
                default:
                    break
                }
            }
            .store(in: &subs)
    }
    
    override func keyDown(with: NSEvent) {
        switch with.keyCode {
        case 36:
            if Defaults.sponsor {
                close()
            } else {
                Task {
                    await pay()
                }
            }
        default:
            super.keyDown(with: with)
        }
    }
    
    override func cancelOperation(_: Any?) {
        close()
    }
    
    @MainActor private func pay() async {
        guard
            session.store.status.value == .ready,
            let product = product
        else { return }
        
        await session.store.purchase(product)
    }
    
    @MainActor private func refresh() async {
        if Defaults.sponsor {
            purchase.state = .hidden
            disclaimer.isHidden = true
            received.isHidden = false
            restore.state = .hidden
        } else {
            purchase.state = .on
            disclaimer.isHidden = false
            received.isHidden = true
            restore.state = .on

            if product == nil {
                product = await session.store.load(item: .sponsor)

                if let product = product {
                    disclaimer.stringValue = "1 time purchase of " + product.displayPrice
                }
            }
        }
    }
}
