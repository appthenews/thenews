import AppKit

extension Control {
    final class Symbol: Control {
        required init?(coder: NSCoder) { nil }
        init(symbol: String, size: CGFloat) {
            let image = NSImageView(image: .init(systemSymbolName: symbol,
                                                 accessibilityDescription: nil) ?? .init())
            image.translatesAutoresizingMaskIntoConstraints = false
            image.symbolConfiguration = .init(pointSize: size, weight: .regular)
            image.contentTintColor = .secondaryLabelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 7
            layer!.cornerCurve = .continuous
            addSubview(image)
            
            widthAnchor.constraint(equalToConstant: 30).isActive = true
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .pressed, .highlighted:
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
