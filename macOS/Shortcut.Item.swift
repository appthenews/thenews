import AppKit
import Combine
import News

extension Shortcut {
    final class Item: Control {
        private weak var background: Vibrant!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(session: Session, item: News.Item) {
            let background = Vibrant(layer: true)
            background.layer!.cornerRadius = 12
            self.background = background
            
            super.init(layer: true)
            layer!.masksToBounds = false
            addSubview(background)
            
            let separator = Separator()
            addSubview(separator)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byTruncatingTail
            
            let string = NSMutableAttributedString()
            string.append(.init(string: item.feed.provider.title + "\n",
                                attributes: [
                                    .font: NSFont.preferredFont(forTextStyle: .footnote),
                                    .foregroundColor: NSColor.secondaryLabelColor]))
            string.append(.init(string: item.title,
                                attributes: [
                                    .font: NSFont.preferredFont(forTextStyle: .body),
                                    .foregroundColor: NSColor.labelColor,
                                    .paragraphStyle: paragraph,
                                    .kern: 0.5]))
            
            let text = Text(vibrancy: true)
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.maximumNumberOfLines = 2
            text.attributedStringValue = string
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 54).isActive = true
            
            background.topAnchor.constraint(equalTo: topAnchor).isActive = true
            background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            
            separator.topAnchor.constraint(equalTo: bottomAnchor, constant: 0.5).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            click
                .first()
                .sink { [weak self] in
                    NSApp.activate(ignoringOtherApps: true)
                    let window = NSApp
                        .windows
                        .first { $0 is Window }
                    window?.orderFrontRegardless()
                    session.provider.value = item.feed.provider
                    session.item.value = item
                    self?.window?.close()
                }
                .store(in: &subs)
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            NSApp
                .effectiveAppearance
                .performAsCurrentDrawingAppearance {
                    switch state {
                    case .highlighted, .pressed, .selected:
                        background.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
                    default:
                        background.layer!.backgroundColor = .clear
                    }
                }
        }
    }
}
