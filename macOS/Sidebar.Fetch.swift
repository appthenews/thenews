import AppKit

extension Sidebar {
    final class Fetch: NSView {
        private weak var base: ShapeLayer!
        private weak var progress: ShapeLayer!
        
        required init?(coder: NSCoder) { nil }
        init() {
            let base = ShapeLayer()
            self.base = base
            
            let progress = ShapeLayer()
            self.progress = progress
            
            super.init(frame: .zero)
            wantsLayer = true
            translatesAutoresizingMaskIntoConstraints = false
            
            let icon = NSImageView(image: .init(systemSymbolName: "cloud.bolt.fill", accessibilityDescription: nil) ?? .init())
            icon.symbolConfiguration = .init(pointSize: 20, weight: .light)
                .applying(.init(hierarchicalColor: .tertiaryLabelColor))
            icon.translatesAutoresizingMaskIntoConstraints = false
            addSubview(icon)
            
            base.frame = .init(x: 45, y: 44, width: 145, height: 6)
            base.path = .init(roundedRect: .init(x: 0, y: 0, width: 120, height: 6),
                              cornerWidth: 3,
                              cornerHeight: 3,
                              transform: nil)
            layer!.addSublayer(base)
            
            progress.frame = .init(x: 45, y: 44, width: 145, height: 8)
            layer!.addSublayer(progress)
            
            widthAnchor.constraint(equalToConstant: 185).isActive = true
            heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 6).isActive = true
            icon.centerYAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        }
        
        func update(value: Double) {
            progress.path = .init(roundedRect: .init(x: 0, y: 0, width: 120 * value, height: 6),
                                  cornerWidth: 3,
                                  cornerHeight: 3,
                                  transform: nil)
        }
        
        override var allowsVibrancy: Bool {
            true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            NSApp
                .effectiveAppearance
                .performAsCurrentDrawingAppearance {
                    base.fillColor = NSColor.quaternaryLabelColor.cgColor
                    progress.fillColor = NSColor.tertiaryLabelColor.cgColor
                }
        }
    }
}
