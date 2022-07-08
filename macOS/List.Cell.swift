import AppKit

extension List {
    final class Cell: NSView {
        var info: Info?
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init(frame: .zero)
            layer = Layer()
            wantsLayer = true
            updateLayer()
        }
        
        var state = State.none {
            didSet {
                updateLayer()
            }
        }
        
        override func hitTest(_: NSPoint) -> NSView? {
            nil
        }
    }
}
