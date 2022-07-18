import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let recent: Bool
        let rect: CGRect
        
        init(item: Item, y: CGFloat, appearance: Appearance) {
            let string = NSMutableAttributedString()
            string.append(.init(string: item.feed.provider.title, attributes: [.foregroundColor: NSColor.secondaryLabelColor]))
            string.append(.init(string: " - ", attributes: [.foregroundColor: NSColor.secondaryLabelColor]))
            string.append(.init(string: item.date.formatted(.relative(presentation: .named,
                                                                      unitsStyle: .wide)), attributes: [.foregroundColor: NSColor.secondaryLabelColor]))
            string.append(.init(string: item.title, attributes: [.foregroundColor: NSColor.labelColor]))
            self.string = string
            
            let height = string.boundingRect(
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
