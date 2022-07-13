import AppKit
import Combine

extension Middlebar {
    final class Field: NSTextField, NSTextFieldDelegate {
        private let session: Session
        private var subs = Set<AnyCancellable>()
        
        override var canBecomeKeyView: Bool {
            false
        }
        
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            Self.cellClass = Cell.self
            self.session = session
            
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .preferredFont(forTextStyle: .body)
            controlSize = .large
            lineBreakMode = .byTruncatingTail
            textColor = .labelColor
            isAutomaticTextCompletionEnabled = false
            placeholderString = "Search"
            wantsLayer = true
            layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            delegate = self
            
            session
                .provider
                .removeDuplicates()
                .sink { [weak self] _ in
                    self?.stringValue = ""
                    self?.undoManager?.removeAllActions()
                    session.search.send("")
                }
                .store(in: &subs)
        }
        
        deinit {
            NSApp
                .windows
                .forEach {
                    $0.undoManager?.removeAllActions()
                }
        }
        
        override func cancelOperation(_: Any?) {
            window?.makeFirstResponder(nil)
        }
        
        override func becomeFirstResponder() -> Bool {
            undoManager?.removeAllActions()
            return super.becomeFirstResponder()
        }
        
        func controlTextDidChange(_ notification: Notification) {
            guard let search = notification.object as? Field else { return }
            session.search.send(search.stringValue)
        }
        
//        func control(_ control: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
//            switch doCommandBy {
//            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
//                fatalError()
//            case #selector(insertNewline):
//                fatalError()
//            case #selector(moveUp):
//                fatalError()
//            case #selector(moveDown):
//                fatalError()
//            default:
//                fatalError()
//            }
//        }
    }
}
