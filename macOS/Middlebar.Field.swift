import AppKit

extension Middlebar {
    final class Field: NSTextField {
        override var canBecomeKeyView: Bool {
            false
        }
        
        required init?(coder: NSCoder) { nil }
        init() {
            Self.cellClass = Cell.self
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .preferredFont(forTextStyle: .body)
            controlSize = .large
            lineBreakMode = .byTruncatingTail
            textColor = .white
            isAutomaticTextCompletionEnabled = false
            placeholderString = "Search"
            wantsLayer = true
            layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
        }
        
        deinit {
            NSApp
                .windows
                .forEach {
                    $0.undoManager?.removeAllActions()
                }
        }
        
        // undoManager?.removeAllActions()
        
        override func cancelOperation(_: Any?) {
            window?.makeFirstResponder(nil)
        }
        
        override func becomeFirstResponder() -> Bool {
            undoManager?.removeAllActions()
            return super.becomeFirstResponder()
        }
    }
}
