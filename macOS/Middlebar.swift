import AppKit
import Combine

final class Middlebar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        let items = session
            .provider
            .removeDuplicates()
            .combineLatest(session
                .cloud) { provider, model in
                    provider == nil
                    ? []
                    : model.items(provider: provider!)
                }
                .removeDuplicates()
                .eraseToAnyPublisher()
        
        super.init(frame: .zero)
        state = .active
        material = .menu
        translatesAutoresizingMaskIntoConstraints = false
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        let field = Field()
        addSubview(field)
        
        let filter = Control.Symbol(symbol: "line.3.horizontal.decrease.circle", size: 18)
        filter
            .click
            .sink {
                
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
        
        let list = List(session: session, items: items)
        addSubview(list)
        
        field.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        field.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        filter.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        filter.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        count.centerYAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
        let trailing = count.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -20)
        let leading = count.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor)
        trailing.priority = .defaultLow
        trailing.isActive = true
        leading.isActive = true
        
        divider.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 20).isActive = true
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
                width.constant = $0 < 2 ? 291 : 0
                leading.constant = $0 == 1 ? 195 : 20
            }
            .store(in: &subs)
        
        items
            .sink { items in
                if items.isEmpty {
                    count.attributedStringValue = .init()
                } else {
                    var string = AttributedString(items.count.formatted(),
                                                  attributes: countAttributes)
                    string.append(AttributedString(items.count == 1 ? " article" : " articles",
                                                   attributes: titleAttributes))
                    count.attributedStringValue = .init(string)
                }
            }
            .store(in: &subs)
    }
}
