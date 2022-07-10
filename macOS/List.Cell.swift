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
                a.string = info.string
                a.frame.size.height = info.rect.height - 30
            }
        }
        
        var state = State.none {
            didSet {
                updateLayer()
            }
        }
        
        private weak var label: Text!
        private weak var vibrant: Vibrant!
        private weak var a: CATextLayer!
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let vibrant = Vibrant(layer: true)
            vibrant.translatesAutoresizingMaskIntoConstraints = true
            vibrant.layer!.cornerCurve = .continuous
            vibrant.layer!.cornerRadius = 12
            vibrant.frame = .init(x: 10, y: 0, width: 260, height: 0)
            self.vibrant = vibrant

            let a = CATextLayer()
            a.frame = .init(x: 15, y: 15, width: 230, height: 0)
            a.contentsScale = 2
            a.isWrapped = true
            self.a = a
            
            
            let label = Text(vibrancy: true)
            label.translatesAutoresizingMaskIntoConstraints = true
            label.frame = .init(x: 25, y: 15, width: 230, height: 0)
            label.wantsLayer = true
            label.layer!.masksToBounds = false
            self.label = label
            
            super.init(frame: .zero)
            addSubview(vibrant)
            addSubview(label)
            vibrant.layer!.addSublayer(a)
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
