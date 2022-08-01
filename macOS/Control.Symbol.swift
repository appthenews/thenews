import AppKit

extension Control {
    final class Symbol: Control {
        private(set) weak var image: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        init(symbol: String, size: CGFloat) {
            let image = NSImageView(image: .init(systemSymbolName: symbol,
                                                 accessibilityDescription: nil) ?? .init())
            image.translatesAutoresizingMaskIntoConstraints = false
            image.symbolConfiguration = .init(pointSize: size, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            self.image = image
            
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
            
            NSApp
                .effectiveAppearance
                .performAsCurrentDrawingAppearance {
                    switch state {
                    case .pressed, .highlighted:
                        layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
                    default:
                        layer!.backgroundColor = .clear
                    }
                }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
