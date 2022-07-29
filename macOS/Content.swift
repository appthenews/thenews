import AppKit
import Combine
import News

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
        header.maximumNumberOfLines = 1
        header.isHidden = true
        addSubview(header)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.drawsBackground = false
        scroll.automaticallyAdjustsContentInsets = false
        scroll.isHidden = true
        addSubview(scroll)
        
        let title = Text(vibrancy: true)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.isSelectable = true
        title.alignment = .justified
        title.textColor = .labelColor
        flip.addSubview(title)
        
        let description = Text(vibrancy: true)
        description.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        description.isSelectable = true
        description.alignment = .justified
        description.textColor = .labelColor
        flip.addSubview(description)
        
        let empty = Vibrant(layer: false)
        addSubview(empty)
        
        let image = NSImageView(image: .init(named: "Logo") ?? .init())
        image.contentTintColor = .quaternaryLabelColor
        image.translatesAutoresizingMaskIntoConstraints = false
        empty.addSubview(image)
        
        header.centerYAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
        header.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -162).isActive = true
        let leading = header.leftAnchor.constraint(equalTo: leftAnchor)
        leading.isActive = true
        
        scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: flip.topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: description.leftAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: description.rightAnchor).isActive = true
        
        description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        description.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 60).isActive = true
        description.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -60).isActive = true
        description.widthAnchor.constraint(lessThanOrEqualToConstant: 800).isActive = true
        description.bottomAnchor.constraint(equalTo: flip.bottomAnchor, constant: -40).isActive = true
        
        empty.topAnchor.constraint(equalTo: topAnchor).isActive = true
        empty.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        empty.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        empty.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        image.centerXAnchor.constraint(equalTo: empty.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: empty.centerYAnchor).isActive = true
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byTruncatingTail
        
        session
            .columns
            .sink {
                leading.constant = $0 == 2 ? 195 : 60
            }
            .store(in: &subs)
        
        session
            .item
            .combineLatest(session.font)
            .removeDuplicates { first, second in
                first.0 == second.0 && first.1 == second.1
            }
            .sink { item, font in
                if let item = item {
                    empty.isHidden = true
                    
                    let string = NSMutableAttributedString()
                    string.append(.init(string: item.feed.provider.title,
                                        attributes: [
                                            .font: NSFont.systemFont(ofSize: 11 + font, weight: .light),
                                            .foregroundColor: NSColor.secondaryLabelColor,
                                            .paragraphStyle: paragraph]))
                    string.append(.init(string: " – " + item
                        .date
                        .formatted(.relative(presentation: .named, unitsStyle: .wide)),
                                        attributes: [
                                            .font: NSFont.systemFont(ofSize: 11 + font, weight: .light),
                                            .foregroundColor: NSColor.tertiaryLabelColor,
                                            .paragraphStyle: paragraph]))
                    
                    header.attributedStringValue = string
                    
                    title.attributedStringValue = .init(
                        string: item.title,
                        attributes: [.font: NSFont.systemFont(ofSize: 18 + font, weight: .medium),
                                     .kern: 1])
                    
                    description.attributedStringValue = .init(
                        string: item.description,
                        attributes: [.font: NSFont.systemFont(ofSize: 14 + font, weight: .regular),
                                     .kern: 1])
                    
                    Task {
                        await session.cloud.read(item: item)
                    }
                    
                    session.review()
                } else {
                    header.attributedStringValue = .init()
                    title.attributedStringValue = .init()
                    description.attributedStringValue = .init()
                    empty.isHidden = false
                }
            }
            .store(in: &subs)
        
        session
            .loading
            .filter {
                !$0
            }
            .sink { _ in
                header.isHidden = false
                scroll.isHidden = false
            }
            .store(in: &subs)
    }
}
