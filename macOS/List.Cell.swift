import AppKit

extension List {
    final class Cell: NSView {
        var info: Info? {
            didSet {
                guard
                    info != oldValue,
                    let info = info
                else { return }
                
                separator.isHidden = info.rect.minX == 0
                
                if info.rect != oldValue?.rect {
                    frame = info.rect
                }
                
                label.attributedStringValue = info.string
            }
        }
        
        var state = State.none {
            didSet {
                updateLayer()
            }
        }
        
        private weak var label: Text!
        private weak var separator: Separator!
        private weak var vibrant: Vibrant!
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let vibrant = Vibrant(layer: true)
            vibrant.layer!.cornerCurve = .continuous
            vibrant.layer!.cornerRadius = 12
            self.vibrant = vibrant
            
            let separator = Separator()
            self.separator = separator
            
            super.init(frame: .zero)
            addSubview(vibrant)
            addSubview(separator)
            
            let label = Text(vibrancy: true)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(label)
            self.label = label
            
            vibrant.topAnchor.constraint(equalTo: topAnchor).isActive = true
            vibrant.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            vibrant.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            vibrant.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            separator.bottomAnchor.constraint(equalTo: topAnchor, constant: -0.5).isActive = true
            
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
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
