import AppKit
import Combine

final class Content: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        state = .active
        material = .sidebar
        translatesAutoresizingMaskIntoConstraints = false
        
        let header = Text(vibrancy: true)
        header.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        header.alignment = .right
        header.textColor = .secondaryLabelColor
        addSubview(header)
        
        let divider = Separator()
        addSubview(divider)
        
        let content = Text(vibrancy: true)
        content.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
        content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        content.textColor = .labelColor
        addSubview(content)
        
        header.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        header.leftAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        divider.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        content.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 30).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        content.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        content.widthAnchor.constraint(lessThanOrEqualToConstant: 600).isActive = true
        
        let attributesProvider = AttributeContainer([
            .font: NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize,
                weight: .regular)])
        
        let attributesDate = AttributeContainer([.font: NSFont.systemFont(
            ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize,
            weight: .light)])
        
        session
            .item
            .sink {
                if let item = $0 {
                    var string = AttributedString(item.feed.provider.title, attributes: attributesProvider)
                    string.append(AttributedString(" — ", attributes: attributesDate))
                    string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                                 unitsStyle: .wide)),
                                                   attributes: attributesDate))
                    header.attributedStringValue = .init(string)
                    content.stringValue = item.description
                } else {
                    header.attributedStringValue = .init()
                    content.stringValue = ""
                }
            }
            .store(in: &subs)
    }
}
