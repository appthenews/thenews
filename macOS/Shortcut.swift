import AppKit
import Combine

private let width = CGFloat(340)

final class Shortcut: NSView {
    private var subs = Set<AnyCancellable>()

    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: 400)))
        
        let separator = Separator()
        addSubview(separator)
        
        let background = NSVisualEffectView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.material = .hudWindow
        background.state = .active
        addSubview(background)
        
        let title = Text(vibrancy: true)
        title.stringValue = "Recently read"
        title.font = .preferredFont(forTextStyle: .body)
        title.textColor = .secondaryLabelColor
        addSubview(title)
        
        let preferences = Control.Symbol(symbol: "slider.vertical.3", size: 16)
        preferences.toolTip = "Preferences"
        preferences
            .click
            .sink {
                (NSApp as! App).showPreferencesWindow(nil)
            }
            .store(in: &subs)
        addSubview(preferences)
        
        let sponsor = Control.Symbol(symbol: "arrow.up.heart", size: 16)
        sponsor.toolTip = "Sponsor"
        sponsor
            .click
            .sink {
                (NSApp as! App).showSponsor(nil)
            }
            .store(in: &subs)
        addSubview(sponsor)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.scrollerInsets.top = 5
        scroll.scrollerInsets.bottom = 5
        scroll.automaticallyAdjustsContentInsets = false
        background.addSubview(scroll)
        
        let stack = Stack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 2
        flip.addSubview(stack)
        
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        title.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        
        preferences.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        preferences.rightAnchor.constraint(equalTo: sponsor.leftAnchor, constant: -10).isActive = true
        
        sponsor.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        sponsor.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        scroll.topAnchor.constraint(equalTo: background.topAnchor, constant: 1).isActive = true
        scroll.leftAnchor.constraint(equalTo: background.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: background.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: background.bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        flip.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20).isActive = true
        
        stack.topAnchor.constraint(equalTo: flip.topAnchor, constant: 20).isActive = true
        stack.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 8).isActive = true
        stack.widthAnchor.constraint(equalToConstant: width - 16).isActive = true
        
        session
            .cloud
            .map(\.recents)
            .sink { items in
                stack.setViews(items
                    .map {
                        Item(session: session, item: $0)
                    }, in: .center)
            }
            .store(in: &subs)
    }
}
