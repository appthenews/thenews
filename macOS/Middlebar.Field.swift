import AppKit
import Combine

extension Middlebar {
    final class Field: NSTextField {
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
            layer!.cornerRadius = 8
            layer!.cornerCurve = .continuous
            
            session
                .provider
                .removeDuplicates()
                .sink { [weak self] _ in
                    self?.cancelOperation(nil)
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
            stringValue = ""
            undoManager?.removeAllActions()
            session.search.send("")
            window?.makeFirstResponder(window?.contentView)
        }
        
        override func becomeFirstResponder() -> Bool {
            undoManager?.removeAllActions()
            return super.becomeFirstResponder()
        }
    }
}
