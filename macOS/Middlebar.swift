import AppKit
import Combine

final class Middlebar: NSVisualEffectView {
    var show: Bool {
        didSet {
            width?.constant = show ? 180 : 1
            UserDefaults.standard.set(show, forKey: "middlebar")
        }
    }
    
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
        
        let separator = Separator()
        addSubview(separator)
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        session
            .middlebar
            .sink { [weak self] in
                self?.show.toggle()
            }
            .store(in: &subs)
    }
}
