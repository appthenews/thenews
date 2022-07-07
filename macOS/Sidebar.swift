import AppKit
import Combine

final class Sidebar: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        var show = UserDefaults.standard.value(forKey: "sidebar") as? Bool ?? true
        
        super.init(frame: .zero)
        state = .active
        material = .hudWindow
        translatesAutoresizingMaskIntoConstraints = false
        let width = widthAnchor.constraint(equalToConstant: show ? 120 : 0)
        width.isActive = true
        
        let separator = Separator()
        addSubview(separator)
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        var first = true
        
        session
            .cloud
            .map(\.preferences.sources)
            .map {
                $0.filter(\.value)
            }
            .removeDuplicates()
            .sink { sources in
                if sources.isEmpty && first {
                    (NSApp as! App).showPreferencesWindow(nil)
                }
                
                first = false
            }
            .store(in: &subs)
        
        session
            .sidebar
            .sink {
                show.toggle()
                width.constant = show ? 120 : 0
                UserDefaults.standard.set(show, forKey: "sidebar")
            }
            .store(in: &subs)
    }
}
