import AppKit
import News

extension Sidebar {
    final class Item: Control {
        let provider: Provider
        
        required init?(coder: NSCoder) { nil }
        init(provider: Provider) {
            self.provider = provider
            
            let text = Text(vibrancy: false)
            text.stringValue = provider.title
            text.font = .preferredFont(forTextStyle: .callout)
            text.textColor = .secondaryLabelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            layer!.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 12).isActive = true
            widthAnchor.constraint(equalToConstant: 130).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .highlighted, .pressed, .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
