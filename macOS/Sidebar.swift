import AppKit
import Combine

final class Sidebar: NSVisualEffectView {
    var show: Bool {
        didSet {
            width?.constant = show ? 120 : 0
            UserDefaults.standard.set(show, forKey: "sidebar")
        }
    }
    
    private weak var width: NSLayoutConstraint?
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        show = UserDefaults.standard.value(forKey: "sidebar") as? Bool ?? true
        
        super.init(frame: .zero)
        state = .active
        material = .hudWindow
        translatesAutoresizingMaskIntoConstraints = false
        width = widthAnchor.constraint(equalToConstant: show ? 120 : 0)
        width!.isActive = true
        
        let separator = Separator()
        addSubview(separator)
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        session
            .sidebar
            .sink { [weak self] in
                self?.show.toggle()
            }
            .store(in: &subs)
    }
}
