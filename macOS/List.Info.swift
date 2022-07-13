import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let recent: Bool
        let rect: CGRect
        
        init(item: Item, y: CGFloat, provider: AttributeContainer, date: AttributeContainer, title: AttributeContainer) {
            var provider = provider
            var date = date
            var title = title
            
            switch item.status {
            case .new:
                provider.foregroundColor = .secondaryLabelColor
                date.foregroundColor = .secondaryLabelColor
                title.foregroundColor = .labelColor
            default:
                provider.foregroundColor = .tertiaryLabelColor
                date.foregroundColor = .tertiaryLabelColor
                title.foregroundColor = .tertiaryLabelColor
            }
            
            var string = AttributedString(item.feed.provider.title, attributes: provider)
            string.append(AttributedString(" — ", attributes: date))
            string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                         unitsStyle: .wide)),
                                           attributes: date))
            string.append(AttributedString("\n", attributes: title))
            string.append(AttributedString(item.title, attributes: title))
            self.string = .init(string)
            
            let height = CTFramesetterSuggestFrameSizeWithConstraints(
                CTFramesetterCreateWithAttributedString(self.string),
                CFRange(),
                nil,
                .init(width: 226,
                      height: CGFloat.greatestFiniteMagnitude),
                nil)
                .height
            
            rect = .init(x: 0, y: y, width: 290, height: ceil(height) + 20)
            recent = item.recent
            self.item = item
        }
        
        func hash(into: inout Hasher) {
            into.combine(item.link)
            into.combine(item.status)
            into.combine(string)
            into.combine(rect)
            into.combine(recent)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.item.link == rhs.item.link
            && lhs.item.status == rhs.item.status
            && lhs.string == rhs.string
            && lhs.rect == rhs.rect
            && lhs.recent == rhs.recent
        }
    }
}
