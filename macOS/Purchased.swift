import AppKit
import Combine

final class Purchased: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 300, height: 300),
                   styleMask: [.titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .hudWindow
        contentView = content
        center()
        
        let image = NSImageView(image: .init(systemSymbolName: "arrow.up.heart.fill", accessibilityDescription: nil) ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.symbolConfiguration = .init(pointSize: 60, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .controlAccentColor))
        content.addSubview(image)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let string = NSMutableAttributedString()
        string.append(.init(string: "Sponsor\n",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize,
                                                         weight: .medium),
                                .foregroundColor: NSColor.labelColor,
                                .paragraphStyle: paragraph]))
        string.append(.init(string: "We received your\ncontribution.",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize,
                                                         weight: .light),
                                .foregroundColor: NSColor.secondaryLabelColor,
                                .paragraphStyle: paragraph]))
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = string
        content.addSubview(text)
        
        let accept = Control.Prominent(title: "OK")
        accept
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        content.addSubview(accept)
        
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 60).isActive = true
        
        text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        text.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        accept.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -50).isActive = true
        accept.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        accept.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    override func keyDown(with: NSEvent) {
        switch with.keyCode {
        case 36:
            close()
        default:
            super.keyDown(with: with)
        }
    }
    
    override func cancelOperation(_: Any?) {
        close()
    }
}
