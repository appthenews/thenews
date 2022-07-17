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
                label.frame.size.height = info.rect.height - 10
                
                if info.recent {
                    recent.frame.origin.y = (info.rect.height - 12) / 2
                    recent.isHidden = false
                    bookmark.isHidden = true
                } else if info.item.status == .bookmarked {
                    recent.isHidden = true
                    bookmark.frame.origin.y = (info.rect.height - 30) / 2
                    bookmark.isHidden = false
                } else {
                    recent.isHidden = true
                    bookmark.isHidden = true
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
        private weak var bookmark: NSImageView!
        
        required init?(coder: NSCoder) { nil }
        required init() {
            let vibrant = Vibrant(layer: true)
            vibrant.translatesAutoresizingMaskIntoConstraints = true
            vibrant.layer!.cornerCurve = .continuous
            vibrant.layer!.cornerRadius = 10
            vibrant.frame = .init(x: 10, y: 0, width: 270, height: 0)
            self.vibrant = vibrant

            let label = TextLayer()
            label.frame = .init(x: 15, y: -6, width: 220, height: 0)
            label.contentsScale = NSScreen.main?.backingScaleFactor ?? 2
            label.isWrapped = true
            vibrant.layer!.addSublayer(label)
            self.label = label
            
            let recent = ShapeLayer()
            recent.isHidden = true
            recent.frame = .init(x: 260, y: 0, width: 12, height: 12)
            recent.path = .init(ellipseIn: .init(x: 1, y: 1, width: 10, height: 10), transform: nil)
            recent.fillColor = NSColor.controlAccentColor.cgColor
            self.recent = recent
            
            let bookmark = NSImageView(image: .init(systemSymbolName: "bookmark", accessibilityDescription: nil) ?? .init())
            bookmark.isHidden = true
            bookmark.frame = .init(x: 241, y: 0, width: 30, height: 30)
            bookmark.symbolConfiguration = .init(pointSize: 15, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))
            vibrant.addSubview(bookmark)
            self.bookmark = bookmark
            
            super.init(frame: .zero)
            wantsLayer = true
            addSubview(vibrant)
            layer!.addSublayer(recent)
        }
        
        override func updateLayer() {
            switch state {
            case .highlighted, .selected:
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
