import AppKit
import Combine

final class Middlebar: NSVisualEffectView {
    var show: Bool {
        didSet {
            width?.constant = show ? 180 : 0
            UserDefaults.standard.set(show, forKey: "middlebar")
        }
    }
    
    private var bookmarks = false
    private weak var width: NSLayoutConstraint?
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        show = UserDefaults.standard.value(forKey: "middlebar") as? Bool ?? true
        
        super.init(frame: .zero)
        state = .active
        material = .popover
        translatesAutoresizingMaskIntoConstraints = false
        width = widthAnchor.constraint(equalToConstant: show ? 180 : 0)
        width!.isActive = true
        
        let field = Field()
        addSubview(field)
        
        let count = Text(vibrancy: true)
        count.textColor = .secondaryLabelColor
        count.font = .preferredFont(forTextStyle: .callout)
        count.stringValue = "123 articles"
        count.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(count)
        
        let bookmark = Button(symbol: "bookmark")
        bookmark
            .click
            .sink { [weak self] in
                guard let self = self else { return }
                self.bookmarks.toggle()
                bookmark.state = self.bookmarks ? .selected : .on
            }
            .store(in: &subs)
        addSubview(bookmark)
        
        let divider = Separator()
        addSubview(divider)
        
        let separator = Separator()
        addSubview(separator)
        
        field.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        field.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        field.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        count.leftAnchor.constraint(equalTo: field.leftAnchor).isActive = true
        count.centerYAnchor.constraint(equalTo: bookmark.centerYAnchor).isActive = true
        count.rightAnchor.constraint(lessThanOrEqualTo: bookmark.leftAnchor, constant: -10).isActive = true
        
        bookmark.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10).isActive = true
        bookmark.rightAnchor.constraint(equalTo: field.rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        divider.topAnchor.constraint(equalTo: bookmark.bottomAnchor, constant: 10).isActive = true
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        session
            .middlebar
            .sink { [weak self] in
                self?.show.toggle()
            }
            .store(in: &subs)
    }
}
