import AppKit

extension List {
    final class Cell: NSView {
        var info: Info? {
            didSet {
                guard
                    info != oldValue,
                    let info = info
                else { return }
                
                frame = info.rect
                vibrant.frame.size.height = info.rect.height
                label.string = info.string
                label.frame.size.height = info.rect.height - 30
                
                if info.item.recent {
                    recent.frame.origin.y = (info.rect.height - 12) / 2
                    recent.isHidden = false
                } else {
                    recent.isHidden = true
                }
            }
        }
        
        var state = State.none {
            didSet {
                updateLayer()
            }
        }
        
        private weak var vibrant: Vibrant!
        private weak var label: CATextLayer!
        private weak var recent: CAShapeLayer!
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let vibrant = Vibrant(layer: true)
            vibrant.translatesAutoresizingMaskIntoConstraints = true
            vibrant.layer!.cornerCurve = .continuous
            vibrant.layer!.cornerRadius = 13
            vibrant.frame = .init(x: 10, y: 0, width: 270, height: 0)
            self.vibrant = vibrant

            let label = CATextLayer()
            label.frame = .init(x: 20, y: 15, width: 230, height: 0)
            label.contentsScale = NSScreen.main?.backingScaleFactor ?? 2
            label.isWrapped = true
            vibrant.layer!.addSublayer(label)
            self.label = label
            
            let recent = CAShapeLayer()
            recent.frame = .init(x: 15, y: 0, width: 12, height: 12)
            recent.path = .init(ellipseIn: .init(x: 2, y: 2, width: 8, height: 8), transform: nil)
            recent.fillColor = NSColor.controlAccentColor.cgColor
            self.recent = recent
            
            super.init(frame: .zero)
            wantsLayer = true
            addSubview(vibrant)
            layer!.addSublayer(recent)
        }
        
        override func updateLayer() {
            switch state {
            case .highlighted, .pressed:
                vibrant.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.07).cgColor
            default:
                vibrant.layer!.backgroundColor = .clear
            }
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
