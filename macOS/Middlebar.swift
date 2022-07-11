import AppKit
import Combine

final class Middlebar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        var bookmarks = false
        
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
        
        let count = Text(vibrancy: true)
        count.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(count)
        
        let bookmark = Button(symbol: "bookmark")
        bookmark
            .click
            .sink {
                bookmarks.toggle()
                bookmark.state = bookmarks ? .selected : .on
            }
            .store(in: &subs)
        addSubview(bookmark)
        
        let divider = Separator()
        addSubview(divider)
        
        let separator = Separator()
        addSubview(separator)
        
        let list = List(session: session, items: items)
        addSubview(list)
        
        field.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        field.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        count.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        count.centerYAnchor.constraint(equalTo: bookmark.centerYAnchor).isActive = true
        count.rightAnchor.constraint(lessThanOrEqualTo: bookmark.leftAnchor, constant: -10).isActive = true
        
        bookmark.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10).isActive = true
        bookmark.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        divider.topAnchor.constraint(equalTo: bookmark.bottomAnchor, constant: 10).isActive = true
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
        
        session
            .middlebar
            .sink {
                width.constant = $0 ? 291 : 0
                UserDefaults.standard.set($0, forKey: "middlebar")
            }
            .store(in: &subs)
        
        items
            .sink { items in
                if items.isEmpty {
                    count.attributedStringValue = .init()
                } else {
                    var string = AttributedString(items.count.formatted(),
                                                  attributes:
                            .init([.font : NSFont
                                .monospacedDigitSystemFont(
                                    ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize,
                                    weight: .regular),
                                   .foregroundColor: NSColor.secondaryLabelColor]))
                    string.append(AttributedString(items.count == 1 ? " article" : " articles",
                                                   attributes:
                            .init([.font : NSFont.preferredFont(forTextStyle: .callout),
                                   .foregroundColor: NSColor.tertiaryLabelColor])))
                    count.attributedStringValue = .init(string)
                }
            }
            .store(in: &subs)
    }
}
