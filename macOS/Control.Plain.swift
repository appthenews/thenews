import AppKit

extension Control {
    final class Plain: Control {
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
            self.text = text
            
            super.init(layer: true)
            layer!.cornerRadius = 6
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 6).isActive = true
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            NSApp
                .effectiveAppearance
                .performAsCurrentDrawingAppearance {
                    switch state {
                    case .off:
                        layer!.backgroundColor = .clear
                        text.textColor = .tertiaryLabelColor
                    case .highlighted, .pressed:
                        layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
                        text.textColor = .secondaryLabelColor
                    default:
                        layer!.backgroundColor = .clear
                        text.textColor = .secondaryLabelColor
                    }
                }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
