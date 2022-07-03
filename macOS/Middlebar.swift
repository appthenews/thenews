import AppKit
import Combine

final class Middlebar: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        state = .active
        material = .popover
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 180).isActive = true
        
        let separator = Separator()
        addSubview(separator)
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
