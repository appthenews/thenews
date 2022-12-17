import AppKit
import Coffee

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
                label.frame.size.height = info.rect.height - 20
                
                if info.recent {
                    recent.frame.origin.y = info.rect.height - 25
                    recent.isHidden = false
                    bookmark.isHidden = true
                } else if info.item.status == .bookmarked {
                    recent.isHidden = true
                    bookmark.frame.origin.y = info.rect.height - 35
                    bookmark.isHidden = false
                } else {
                    recent.isHidden = true
                    bookmark.isHidden = true
                }
            }
        }
        
        var reader = false {
            didSet {
                guard reader != oldValue else { return }
                updateLayer()
            }
        }
        
        var state = State.none {
            didSet {
                guard state != oldValue else { return }
                updateLayer()
            }
        }
        
        private weak var vibrant: Vibrant!
        private weak var label: CATextLayer!
        private weak var recent: CAShapeLayer!
        private weak var bookmark: NSImageView!
        private weak var separator: Separator!
        
        required init?(coder: NSCoder) { nil }
        init() {
            let vibrant = Vibrant(layer: true)
            vibrant.translatesAutoresizingMaskIntoConstraints = true
            vibrant.frame = .init(x: 0, y: 0, width: 290, height: 0)
            self.vibrant = vibrant

            let label = TextLayer()
            label.frame = .init(x: 25, y: 10, width: 225, height: 0)
            label.contentsScale = NSScreen.main?.backingScaleFactor ?? 2
            label.isWrapped = true
            label.allowsFontSubpixelQuantization = true
            label.masksToBounds = true
            vibrant.layer!.addSublayer(label)
            self.label = label
            
            let recent = ShapeLayer()
            recent.isHidden = true
            recent.frame = .init(x: 268, y: 0, width: 14, height: 14)
            recent.path = .init(ellipseIn: .init(x: 3, y: 3, width: 8, height: 8), transform: nil)
            self.recent = recent
            
            let bookmark = NSImageView(image: .init(systemSymbolName: "bookmark.fill", accessibilityDescription: nil) ?? .init())
            bookmark.isHidden = true
            bookmark.frame = .init(x: 260, y: 0, width: 30, height: 30)
            bookmark.symbolConfiguration = .init(pointSize: 11, weight: .regular)
            vibrant.addSubview(bookmark)
            self.bookmark = bookmark
            
            let separator = Separator()
            separator.translatesAutoresizingMaskIntoConstraints = true
            separator.frame = .init(x: 0, y: -1, width: 290, height: 1)
            self.separator = separator
            
            super.init(frame: .zero)
            wantsLayer = true
            layer!.masksToBounds = false
            addSubview(vibrant)
            addSubview(separator)
            layer!.addSublayer(recent)
        }
        
        override func updateLayer() {
            super.updateLayer()

            NSApp
                .effectiveAppearance
                .performAsCurrentDrawingAppearance {
                    switch state {
                    case .highlighted, .selected:
                        vibrant.layer!.backgroundColor = NSColor(named: "Text")!.withAlphaComponent(0.07).cgColor
                    default:
                        vibrant.layer!.backgroundColor = .clear
                    }
                    
                    recent.fillColor = reader ? NSColor(named: "Text")!.cgColor : NSColor.controlAccentColor.cgColor
                    bookmark.symbolConfiguration = bookmark
                        .symbolConfiguration!
                        .applying(.init(hierarchicalColor: reader ? .init(named: "Text")!: .tertiaryLabelColor))
                }
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
