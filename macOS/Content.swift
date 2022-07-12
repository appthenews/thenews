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
        
        let title = Text(vibrancy: true)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.textColor = .secondaryLabelColor
        title.maximumNumberOfLines = 1
        addSubview(title)
        
        let content = Text(vibrancy: true)
        content.font = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .regular)
        content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        content.textColor = .labelColor
        addSubview(content)
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        title.centerYAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -180).isActive = true
        
        content.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        content.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        content.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        content.widthAnchor.constraint(lessThanOrEqualToConstant: 740).isActive = true
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byTruncatingTail
        
        let attributesProvider = AttributeContainer([
            .font: NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize,
                weight: .regular),
            .paragraphStyle: paragraph])
        
        let attributesDate = AttributeContainer([.font: NSFont.systemFont(
            ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize,
            weight: .light),
                                                 .paragraphStyle: paragraph])
        
        session
            .item
            .removeDuplicates()
            .sink {
                if let item = $0 {
                    var string = AttributedString(item.feed.provider.title, attributes: attributesProvider)
                    string.append(AttributedString(" — ", attributes: attributesDate))
                    string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                                 unitsStyle: .wide)),
                                                   attributes: attributesDate))
                    title.attributedStringValue = .init(string)
                    content.stringValue = item.description
                } else {
                    title.attributedStringValue = .init()
                    content.stringValue = ""
                }
            }
            .store(in: &subs)
    }
}
