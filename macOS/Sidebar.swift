import AppKit
import Combine

final class Sidebar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    private weak var all: Item!
    private weak var theGuardian: Item!
    private weak var reuters: Item!
    private weak var derSpiegel: Item!
    private weak var theLocal: Item!
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
        
        let all = Item(title: "All feeds")
        all
            .click
            .sink {
                self.select(item: all)
                session.provider.send()
            }
            .store(in: &subs)
        self.all = all
        
        let theGuardian = Item(title: "The Guardian")
        self.theGuardian = theGuardian
        
        let reuters = Item(title: "Reuters")
        self.reuters = reuters
        
        let derSpiegel = Item(title: "Der Spiegel")
        self.derSpiegel = derSpiegel
        
        let theLocal = Item(title: "The Local")
        self.theLocal = theLocal
        
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
        
        theGuardian
            .click
            .sink {
                stack.select(control: theGuardian)
            }
            .store(in: &subs)
        
        reuters
            .click
            .sink {
                stack.select(control: reuters)
            }
            .store(in: &subs)
        
        derSpiegel
            .click
            .sink {
                stack.select(control: derSpiegel)
            }
            .store(in: &subs)
        
        theLocal
            .click
            .sink {
                stack.select(control: theLocal)
            }
            .store(in: &subs)
        
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
            .sink { sources in
                if sources.isEmpty && first {
                    (NSApp as! App).showPreferencesWindow(nil)
                }
                
                if sources.contains(.theGuardian) {
                    if theGuardian.state == .hidden {
                        theGuardian.state = .on
                    }
                } else {
                    if theGuardian.state != .hidden {
                        theGuardian.state = .hidden
                    }
                    
                    if session.provider.value == .theGuardian {
                        session.item.send(nil)
                        session.provider.send(nil)
                    }
                }
                
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
    
    private func select(item: Item) {
//        views
//            .compactMap {
//                $0 as? Control
//            }
//            .forEach {
//                $0.state = $0 == control
//                ? .selected
//                : $0.state == .selected
//                    ? .on
//                    : $0.state
//            }
    }
}
