import AppKit
import Combine
import News

final class Sidebar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        state = .active
        material = .hudWindow
        translatesAutoresizingMaskIntoConstraints = false
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        let separator = Separator()
        addSubview(separator)
        
        let all = Item(provider: .all)
        all
            .click
            .sink {
                session.provider.value = .all
            }
            .store(in: &subs)
        
        let theGuardian = Item(provider: .theGuardian)
        theGuardian
            .click
            .sink {
                session.provider.value = .theGuardian
            }
            .store(in: &subs)
        
        let reuters = Item(provider: .reuters)
        reuters
            .click
            .sink {
                session.provider.value = .reuters
            }
            .store(in: &subs)
        
        let derSpiegel = Item(provider: .derSpiegel)
        derSpiegel
            .click
            .sink {
                session.provider.value = .derSpiegel
            }
            .store(in: &subs)
        
        let theLocal = Item(provider: .theLocal)
        theLocal
            .click
            .sink {
                session.provider.value = .theLocal
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
        stack.isHidden = true
        addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        var first = true
        
        session
            .cloud
            .sink { model in
                let providers = model.preferences.providers
                
                if providers.isEmpty && first {
                    (NSApp as! App).showPreferencesWindow(nil)
                }
                
                stack
                    .views
                    .compactMap {
                        $0 as? Item
                    }
                    .forEach { item in
                        if item.provider == .all || providers.contains(item.provider) {
                            if item.state == .hidden {
                                item.state = .on
                            }
                            
                            item.recents = model
                                .items(provider: item.provider)
                                .filter(\.recent)
                                .count
                            
                        } else {
                            if item.state != .hidden {
                                item.state = .hidden
                            }
                        }
                    }
                
                first = false
            }
            .store(in: &subs)
        
        session
            .columns
            .sink {
                width.constant = $0 == 0 ? 195 : 0
            }
            .store(in: &subs)
        
        session
            .provider
            .sink { provider in
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
            .store(in: &subs)
        
        session
            .provider
            .dropFirst()
            .sink { provider in
                UserDefaults.standard.set(provider?.rawValue, forKey: "provider")
            }
            .store(in: &subs)
        
        session
            .ready
            .notify(queue: .main) {
                stack.isHidden = false
            }
    }
}
