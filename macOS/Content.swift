import AppKit
import Combine

final class Content: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        state = .active
        material = .menu
        translatesAutoresizingMaskIntoConstraints = false
        
        let header = Text(vibrancy: true)
        header.textColor = .secondaryLabelColor
        header.font = .preferredFont(forTextStyle: .callout)
        header.stringValue = "The Guardian : Thursday, 3 September."
        header.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        header.alignment = .right
        addSubview(header)
        
        let divider = Separator()
        addSubview(divider)
        
        header.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        header.leftAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        divider.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
