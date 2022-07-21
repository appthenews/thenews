import AppKit

extension Control {
    final class Plain: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
            text.textColor = .secondaryLabelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 8
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            NSApp
                .effectiveAppearance
                .performAsCurrentDrawingAppearance {
                    switch state {
                    case .highlighted, .pressed:
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
