import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let recent: Bool
        let rect: CGRect
        
        init(item: Item, y: CGFloat, appearance: Appearance) {
            var string = AttributedString(item.feed.provider.title, attributes: appearance.provider)
            string.append(AttributedString(" — ", attributes: appearance.date))
            string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                         unitsStyle: .wide)),
                                           attributes: appearance.date))
            string.append(AttributedString("\n\n", attributes: .init([.font : NSFont.systemFont(ofSize: 4)])))
            string.append(AttributedString(item.title, attributes: appearance.title))
            self.string = .init(string)
            
            let height = self.string.boundingRect(
                with: .init(width: 240,
                            height: CGFloat.greatestFiniteMagnitude),
                options: [
                    .usesFontLeading,
                    .usesLineFragmentOrigin,
                        .usesDeviceMetrics])
                .height
            
            rect = .init(x: 0, y: y, width: 310, height: ceil(height) + 30)
            recent = item.recent
            self.item = item
        }
    }
}
