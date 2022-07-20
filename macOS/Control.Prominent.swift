import AppKit

extension Control {
    final class Prominent: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            let text = Text(vibrancy: false)
            text.stringValue = title
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
            text.textColor = .white
            
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
                        layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.95).cgColor
                    default:
                        layer!.backgroundColor = NSColor.controlAccentColor.cgColor
                    }
                }
        }
    }
}
