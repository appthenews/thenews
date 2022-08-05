import AppKit
import Coffee
import Combine
import News

final class Sidebar: NSVisualEffectView {
    private weak var background: NSView!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        let background = NSView()
        background.wantsLayer = true
        self.background = background
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        
        let width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        let separator = Separator()
        addSubview(separator)
        
        let fetch = Fetch()
        fetch.update(value: 0.5)
        
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
            fetch,
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
        
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        session
            .cloud
            .sink { model in
                
                switch model.fetch {
                case .off:
                    fetch.animator().isHidden = true
                case let .on(progress):
                    fetch.animator().isHidden = false
                    fetch.update(value: progress)
                }
                
                let providers = model.preferences.providers
                
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
            .loading
            .filter {
                !$0
            }
            .sink { _ in
                stack.isHidden = false
            }
            .store(in: &subs)
        
        session
            .reader
            .sink { [weak self] in
                if $0 {
                    self?.state = .inactive
                    self?.material = .underPageBackground
                    background.isHidden = false
                    
                    stack
                        .views
                        .compactMap {
                            $0 as? Item
                        }
                        .forEach {
                            $0.color = .init(named: "Text")!
                            $0.recent.layer!.backgroundColor = NSColor(named: "Text")!.cgColor
                            $0.count.textColor = .init(named: "Background")!
                        }
                } else {
                    self?.state = .active
                    self?.material = .hudWindow
                    background.isHidden = true
                    
                    stack
                        .views
                        .compactMap {
                            $0 as? Item
                        }
                        .forEach {
                            $0.color = .labelColor
                            $0.recent.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
                            $0.count.textColor = .white
                        }
                }
            }
            .store(in: &subs)
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        NSApp
            .effectiveAppearance
            .performAsCurrentDrawingAppearance {
                background.layer!.backgroundColor = NSColor(named: "Background")!.cgColor
            }
    }
}
