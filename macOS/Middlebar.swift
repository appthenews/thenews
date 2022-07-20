import AppKit
import Combine

final class Middlebar: NSVisualEffectView {
    private weak var field: Field!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        let field = Field(session: session)
        self.field = field
        
        super.init(frame: .zero)
        state = .active
        material = .menu
        translatesAutoresizingMaskIntoConstraints = false
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        addSubview(field)
        
        let filter = Control.Symbol(symbol: "line.3.horizontal.decrease.circle", size: 18)
        filter.toolTip = "Filters"
        filter
            .click
            .sink {
                let filters = Filters(session: session)
                
                let popover = NSPopover()
                popover.behavior = .transient
                popover.contentSize = filters.frame.size
                popover.contentViewController = .init()
                popover.contentViewController!.view = filters
                popover.show(relativeTo: filter.bounds, of: filter, preferredEdge: .minY)
                popover.contentViewController!.view.window!.makeKey()
            }
            .store(in: &subs)
        addSubview(filter)
        
        let count = Text(vibrancy: true)
        count.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        count.maximumNumberOfLines = 1
        addSubview(count)
        
        let divider = Separator()
        addSubview(divider)
        
        let separator = Separator()
        addSubview(separator)
        
        let list = List(session: session)
        addSubview(list)
        
        field.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        field.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        filter.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        filter.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
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
        list.widthAnchor.constraint(equalToConstant: 310).isActive = true
        
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
            .sink {
                width.constant = $0 < 2 ? 311 : 0
                leading.constant = $0 == 1 ? 195 : 20
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
                case 1:
                    title = "not read"
                default:
                    title = items.count == 1 ? "bookmark" : "bookmarks"
                }
                
                string.append(AttributedString(title, attributes: titleAttributes))
                count.attributedStringValue = .init(string)
            }
            .store(in: &subs)
        
        var dividerTop: NSLayoutConstraint?
        var froob: Froob?
        
        session
            .froob
            .sink { [weak self] in
                guard let self = self else { return }
                
                dividerTop?.isActive = false
                froob?.removeFromSuperview()
                if $0 || true {
                    froob = Froob(session: session)
                    self.addSubview(froob!)
                    
                    froob!.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 20).isActive = true
                    froob!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                    dividerTop = divider.topAnchor.constraint(equalTo: froob!.bottomAnchor, constant: 20)
                } else {
                    dividerTop = divider.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 20)
                }
                dividerTop!.isActive = true
            }
            .store(in: &subs)
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        NSApp
            .effectiveAppearance
            .performAsCurrentDrawingAppearance {
                field.layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            }
    }
}
