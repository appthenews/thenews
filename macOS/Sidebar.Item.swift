import AppKit
import News

extension Sidebar {
    final class Item: Control {
        let provider: Provider
        private weak var vibrant: Vibrant!
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
            
            let vibrant = Vibrant(layer: true)
            vibrant.layer!.cornerRadius = 6
            vibrant.layer!.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            self.vibrant = vibrant
            
            let text = Text(vibrancy: false)
            text.stringValue = provider.title
            text.font = .preferredFont(forTextStyle: .body)
            text.textColor = .secondaryLabelColor
            vibrant.addSubview(text)
            
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
            
            super.init(layer: false)
            addSubview(vibrant)
            addSubview(recent)
            
            vibrant.topAnchor.constraint(equalTo: topAnchor).isActive = true
            vibrant.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            vibrant.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            vibrant.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 12).isActive = true
            widthAnchor.constraint(equalToConstant: 185).isActive = true
            
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
                vibrant.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
            default:
                vibrant.layer!.backgroundColor = .clear
            }
        }
    }
}
