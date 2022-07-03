import AppKit

extension Topbar {
    final class Button: Control {
        required init?(coder: NSCoder) { nil }
        init(symbol: String) {
            super.init(layer: true)
            layer!.cornerRadius = 6
            layer!.cornerCurve = .continuous
            
            let image = NSImageView(image: .init(systemSymbolName: symbol,
                                                 accessibilityDescription: nil) ?? .init())
            image.translatesAutoresizingMaskIntoConstraints = false
            image.symbolConfiguration = .init(pointSize: 14, weight: .regular)
            image.contentTintColor = .controlAccentColor
            addSubview(image)
            
            widthAnchor.constraint(equalToConstant: 26).isActive = true
            heightAnchor.constraint(equalToConstant: 26).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.15).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
