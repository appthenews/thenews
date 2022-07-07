import AppKit
import Combine
import News

final class Sidebar: NSVisualEffectView {
    private weak var stack: Stack!
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        
        var show = UserDefaults.standard.value(forKey: "sidebar") as? Bool ?? true
        
        super.init(frame: .zero)
        state = .active
        material = .hudWindow
        translatesAutoresizingMaskIntoConstraints = false
        let width = widthAnchor.constraint(equalToConstant: show ? 140 : 0)
        width.isActive = true
        
        let separator = Separator()
        addSubview(separator)
        
        let all = Item(provider: .all)
        all
            .click
            .sink {
                self.select(provider: .all)
            }
            .store(in: &subs)
        
        let theGuardian = Item(provider: .theGuardian)
        theGuardian
            .click
            .sink {
                self.select(provider: .theGuardian)
            }
            .store(in: &subs)
        
        let reuters = Item(provider: .reuters)
        reuters
            .click
            .sink {
                self.select(provider: .reuters)
            }
            .store(in: &subs)
        
        let derSpiegel = Item(provider: .derSpiegel)
        derSpiegel
            .click
            .sink {
                self.select(provider: .derSpiegel)
            }
            .store(in: &subs)
        
        let theLocal = Item(provider: .theLocal)
        theLocal
            .click
            .sink {
                self.select(provider: .theLocal)
            }
            .store(in: &subs)
        
        let stack = Stack(views: [
            all,
            theGuardian,
            reuters,
            derSpiegel,
            theLocal])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        addSubview(stack)
        self.stack = stack
        
        stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        var first = true
        
        session
            .cloud
            .map(\.preferences.providers)
            .removeDuplicates()
            .sink { providers in
                if providers.isEmpty && first {
                    (NSApp as! App).showPreferencesWindow(nil)
                }
                
                self.show(providers: providers)
                first = false
            }
            .store(in: &subs)
        
        session
            .sidebar
            .sink {
                show.toggle()
                width.constant = show ? 140 : 0
                UserDefaults.standard.set(show, forKey: "sidebar")
            }
            .store(in: &subs)
    }
    
    private func show(providers: Set<Provider>) {
        stack
            .views
            .compactMap {
                $0 as? Item
            }
            .filter {
                $0.provider != .all
            }
            .forEach { item in
                if providers.contains(item.provider) {
                    if item.state == .hidden {
                        item.state = .on
                    }
                } else {
                    if item.state != .hidden {
                        item.state = .hidden
                    }
                    
                    if session.provider.value == item.provider {
                        session.item.send(nil)
                        session.provider.send(nil)
                    }
                }
            }
    }
    
    private func select(provider: Provider) {
        session.provider.send(provider)
        
        stack
            .views
            .compactMap {
                $0 as? Item
            }
            .forEach {
                if $0.provider == provider {
                    $0.state = .selected
                } else if $0.state == .selected {
                    $0.state = .on
                }
            }
    }
}
