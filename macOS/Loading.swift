import AppKit

final class Loading: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = NSImageView(image: .init(systemSymbolName: "cloud.bolt", accessibilityDescription: nil) ?? .init())
        image.symbolConfiguration = .init(pointSize: 60, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .tertiaryLabelColor))
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        
        let message = Text(vibrancy: false)
        message.stringValue = "Loading..."
        message.textColor = .tertiaryLabelColor
        message.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
        addSubview(message)
        
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        
        message.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30).isActive = true
        message.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
