import AppKit

final class Button: Control {
    var color = NSColor.controlAccentColor {
        didSet {
            image.symbolConfiguration = .init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: color))
        }
    }
    
    private(set) weak var image: NSImageView!
    
    required init?(coder: NSCoder) { nil }
    init(symbol: String) {
        let image = NSImageView(image: .init(systemSymbolName: symbol,
                                             accessibilityDescription: nil) ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
        
        super.init(layer: true)
        layer!.cornerRadius = 6
        layer!.cornerCurve = .continuous
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
            layer!.backgroundColor = color.withAlphaComponent(0.2).cgColor
        default:
            layer!.backgroundColor = .clear
        }
    }
}
