import AppKit

final class Button: Control {
    private weak var image: NSImageView!
    
    required init?(coder: NSCoder) { nil }
    init(symbol: String) {
        let image = NSImageView(image: .init(systemSymbolName: symbol,
                                             accessibilityDescription: nil) ?? .init())
        self.image = image
        
        super.init(layer: true)
        layer!.cornerRadius = 6
        layer!.cornerCurve = .continuous

        image.translatesAutoresizingMaskIntoConstraints = false
        image.symbolConfiguration = .init(pointSize: 14, weight: .regular)
        addSubview(image)
        
        widthAnchor.constraint(equalToConstant: 26).isActive = true
        heightAnchor.constraint(equalToConstant: 26).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        switch state {
        case .selected:
            layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            image.contentTintColor = .white
        case .pressed, .highlighted:
            layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.15).cgColor
            image.contentTintColor = .controlAccentColor
        default:
            layer!.backgroundColor = .clear
            image.contentTintColor = .controlAccentColor
        }
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
