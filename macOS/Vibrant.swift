import AppKit

final class Vibrant: NSView {
    required init?(coder: NSCoder) { nil }
    init(layer: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = layer
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func hitTest(_: NSPoint) -> NSView? {
        nil
    }
}
