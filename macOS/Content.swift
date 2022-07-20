import AppKit
import Combine
import StoreKit
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
        addSubview(header)
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.drawsBackground = false
        scroll.automaticallyAdjustsContentInsets = false
        addSubview(scroll)
        
        let content = Text(vibrancy: true)
        content.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        content.alignment = .right
        content.isSelectable = true
        content.alignment = .justified
        content.textColor = .labelColor
        flip.addSubview(content)
        
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
        
        content.topAnchor.constraint(equalTo: flip.topAnchor, constant: 10).isActive = true
        content.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 60).isActive = true
        content.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -60).isActive = true
        content.widthAnchor.constraint(lessThanOrEqualToConstant: 800).isActive = true
        content.bottomAnchor.constraint(equalTo: flip.bottomAnchor, constant: -40).isActive = true
        
        let paragraphHeader = NSMutableParagraphStyle()
        paragraphHeader.lineBreakMode = .byTruncatingTail
        
        let paragraphContent = NSMutableParagraphStyle()
        paragraphContent.lineBreakMode = .byWordWrapping
        paragraphContent.lineBreakStrategy = .pushOut
        paragraphContent.alignment = .justified
        paragraphContent.allowsDefaultTighteningForTruncation = false
        paragraphContent.tighteningFactorForTruncation = 0
        paragraphContent.usesDefaultHyphenation = false
        paragraphContent.defaultTabInterval = 0
        paragraphContent.hyphenationFactor = 0
        
        var attributesProvider = AttributeContainer([.paragraphStyle: paragraphHeader,
                                                     .foregroundColor: NSColor.secondaryLabelColor])
        var attributesDate = AttributeContainer([.paragraphStyle: paragraphHeader,
                                                 .foregroundColor: NSColor.tertiaryLabelColor])
        var attributesTitle = AttributeContainer([.paragraphStyle: paragraphContent,
                                                  .foregroundColor: NSColor.labelColor])
        var attributesDescription = AttributeContainer([.paragraphStyle: paragraphContent,
                                                        .foregroundColor: NSColor.labelColor])
        
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
                    attributesProvider.font = NSFont.systemFont(
                        ofSize: 11 + .init(font),
                        weight: .light)
                    attributesDate.font = NSFont.systemFont(
                        ofSize: 11 + .init(font),
                        weight: .light)
                    attributesTitle.font = NSFont.systemFont(
                        ofSize: 18 + .init(font),
                        weight: .medium)
                    attributesDescription.font = NSFont.systemFont(
                        ofSize: 14 + .init(font),
                        weight: .regular)
                    
                    content.font = attributesDescription.font
                    
                    var stringHeader = AttributedString(item.feed.provider.title, attributes: attributesProvider)
                    stringHeader.append(AttributedString(" — ", attributes: attributesDate))
                    stringHeader.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                                 unitsStyle: .wide)),
                                                   attributes: attributesDate))
                    
                    var stringContent = AttributedString(item.title, attributes: attributesTitle)
                    stringContent.append(AttributedString("\n\n", attributes: attributesDate))
                    stringContent.append(AttributedString(item.description, attributes: attributesDescription))

                    header.attributedStringValue = .init(stringHeader)
                    content.attributedStringValue = .init(stringContent)
                    
                    Task {
                        await session.cloud.read(item: item)
                    }
                    
                    if Defaults.ready {
                        SKStoreReviewController.requestReview()
                    }
                } else {
                    header.attributedStringValue = .init()
                    content.stringValue = ""
                }
            }
            .store(in: &subs)
    }
}
