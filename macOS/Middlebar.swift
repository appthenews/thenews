import AppKit
import Coffee
import Combine

final class Middlebar: NSVisualEffectView, NSTextFieldDelegate {
    private weak var field: Field!
    private weak var background: NSView!
    private weak var cancel: Control.Plain!
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        
        let field = Field(session: session)
        self.field = field
        
        let cancel = Control.Plain(title: "Cancel")
        cancel.toolTip = "Cancel search"
        self.cancel = cancel
        
        let background = NSView()
        background.wantsLayer = true
        self.background = background
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        field.delegate = self
        field.isHidden = true
        addSubview(field)
        
        let filter = Control.Symbol(symbol: "line.3.horizontal.decrease.circle", size: 18)
        filter.toolTip = "Filters"
        filter.state = .hidden
        filter
            .click
            .sink {
                NSPopover().show(content: Filters(session: session), on: filter, edge: .minY)
            }
            .store(in: &subs)
        addSubview(filter)
        
        cancel.state = .hidden
        cancel
            .click
            .sink { [weak self] in
                field.stringValue = ""
                session.search.send("")
                self?.update()
            }
            .store(in: &subs)
        addSubview(cancel)
        
        let count = Text(vibrancy: true)
        count.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        count.maximumNumberOfLines = 1
        count.isHidden = true
        addSubview(count)
        
        let divider = Separator()
        divider.isHidden = true
        addSubview(divider)
        
        let separator = Separator()
        addSubview(separator)
        
        let list = List(session: session)
        list.isHidden = true
        addSubview(list)
        
        let loading = Loading()
        addSubview(loading)
        
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        field.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        field.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        cancel.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        cancel.leftAnchor.constraint(equalTo: field.rightAnchor, constant: 3).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        filter.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        filter.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        count.centerYAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
        let trailing = count.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20)
        let leading = count.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor)
        trailing.priority = .defaultLow
        trailing.isActive = true
        leading.isActive = true

        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo: divider.bottomAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.widthAnchor.constraint(equalToConstant: 290).isActive = true
        
        loading.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loading.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loading.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        loading.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byTruncatingTail
        
        let countAttributes = AttributeContainer([.font: NSFont
            .monospacedDigitSystemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize,
                weight: .regular),
                                                  .foregroundColor: NSColor.secondaryLabelColor,
                                                  .paragraphStyle: paragraph])
        let titleAttributes = AttributeContainer([.font: NSFont.preferredFont(forTextStyle: .body),
                                                  .foregroundColor: NSColor.tertiaryLabelColor,
                                                  .paragraphStyle: paragraph])
        
        session
            .columns
            .sink { [weak self] in
                width.constant = $0 < 2 ? 291 : 0
                leading.constant = $0 == 1 ? 195 : 20
                
                if $0 == 2,
                    self?.window?.firstResponder == field.currentEditor()
                    || self?.window?.firstResponder == field {
                    self?.window?.makeFirstResponder(self?.window?.contentView)
                }
            }
            .store(in: &subs)
        
        session
            .items
            .combineLatest(session
                .showing
                .removeDuplicates())
            .sink { items, showing in
                var string = AttributedString(items.count.formatted(),
                                              attributes: countAttributes)
                string.append(AttributedString(" ", attributes: titleAttributes))
                
                let title: String
                
                switch showing {
                case 0:
                    title = items.count == 1 ? "article" : "articles"
                    filter.symbol = "line.3.horizontal.decrease.circle"
                case 1:
                    title = "not read"
                    filter.symbol = "line.3.horizontal.decrease.circle.fill"
                default:
                    title = items.count == 1 ? "bookmark" : "bookmarks"
                    filter.symbol = "line.3.horizontal.decrease.circle.fill"
                }
                
                string.append(AttributedString(title, attributes: titleAttributes))
                count.attributedStringValue = .init(string)
            }
            .store(in: &subs)
        
        var dividerTop: NSLayoutConstraint?
        var froob: Froob?
        
        session
            .froob
            .combineLatest(session.loading)
            .sink { [weak self] show, loading in
                guard let self = self else { return }
                
                dividerTop?.isActive = false
                froob?.removeFromSuperview()
                if show && !loading {
                    froob = Froob(session: session)
                    self.addSubview(froob!)
                    
                    froob!.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 40).isActive = true
                    froob!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    dividerTop = divider.topAnchor.constraint(equalTo: froob!.bottomAnchor, constant: 40)
                } else {
                    dividerTop = divider.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 20)
                }
                dividerTop!.isActive = true
            }
            .store(in: &subs)
        
        session
            .loading
            .combineLatest(session.provider)
            .sink { load, provider in
                guard !load else { return }
                
                if provider == nil {
                    count.isHidden = true
                    list.isHidden = true
                    field.isHidden = true
                    filter.state = .hidden
                    cancel.state = .hidden
                } else {
                    loading.removeFromSuperview()
                    count.isHidden = false
                    list.isHidden = false
                    field.isHidden = false
                    filter.state = .on
                    cancel.state = .off
                }
            }
            .store(in: &subs)
        
        session
            .reader
            .sink { [weak self] in
                if $0 {
                    self?.state = .inactive
                    self?.material = .underPageBackground
                    background.isHidden = false
                } else {
                    self?.state = .active
                    self?.material = .menu
                    background.isHidden = true
                }
            }
            .store(in: &subs)
        
        session
            .find
            .sink { [weak self] in
                self?.window?.makeFirstResponder(field)
            }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == list.contentView
            }
            .map {
                $0.bounds.minY < 10
            }
            .removeDuplicates()
            .sink {
                divider.isHidden = $0
            }
            .store(in: &subs)
    }
    
    func controlTextDidChange(_ notification: Notification) {
        guard let search = notification.object as? Field else { return }
        session.search.send(search.stringValue)
        update()
    }
    
    func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
        switch doCommandBy {
        case #selector(cancelOperation):
            field.cancelOperation(nil)
            update()
            return true
        case #selector(complete),
            #selector(NSSavePanel.cancel),
            #selector(insertNewline):
            window!.makeFirstResponder(window!.contentView)
            update()
            return true
        default:
            return false
        }
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        NSApp
            .effectiveAppearance
            .performAsCurrentDrawingAppearance {
                field.layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
                background.layer!.backgroundColor = NSColor(named: "Background")!.cgColor
            }
    }
    
    private func update() {
        cancel.state = field.stringValue.isEmpty ? .off : .on
    }
}
