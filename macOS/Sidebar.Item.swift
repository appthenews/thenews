import AppKit
import News

extension Sidebar {
    final class Item: Control {
        let provider: Provider
        private weak var recent: NSView!
        private weak var count: Text!
        
        var recents = 0 {
            didSet {
                count.stringValue = recents.formatted()
                recent.isHidden = recents == 0
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init(provider: Provider) {
            self.provider = provider
            
            let text = Text(vibrancy: false)
            text.stringValue = provider.title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .secondaryLabelColor
            
            let recent = NSView()
            recent.isHidden = true
            recent.translatesAutoresizingMaskIntoConstraints = false
            recent.wantsLayer = true
            recent.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            recent.layer!.cornerRadius = 9
            self.recent = recent
            
            let count = Text(vibrancy: false)
            count.font = .systemFont(ofSize: 10, weight: .medium)
            count.textColor = .white
            recent.addSubview(count)
            self.count = count
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            layer!.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            addSubview(text)
            addSubview(recent)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 12).isActive = true
            widthAnchor.constraint(equalToConstant: 170).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            
            recent.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            recent.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
            recent.heightAnchor.constraint(equalToConstant: 18).isActive = true
            recent.leftAnchor.constraint(equalTo: count.leftAnchor, constant: -5).isActive = true
            
            count.centerYAnchor.constraint(equalTo: recent.centerYAnchor).isActive = true
            count.rightAnchor.constraint(equalTo: recent.rightAnchor, constant: -5).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .highlighted, .pressed, .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
