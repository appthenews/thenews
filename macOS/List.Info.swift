import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let rect: CGRect
        
        init(item: Item, y: CGFloat) {
            var string = AttributedString(item.title,
                                          attributes: .init())
            
//            text = .make {
//                if !website.title.isEmpty {
//                    $0.append(.make(website.title, attributes: [
//                        .font: NSFont.preferredFont(forTextStyle: .callout),
//                        .foregroundColor: NSColor.labelColor]))
//                }
//
//                $0.append(.make(" " + website.id.domain, attributes: [
//                    .font: NSFont.preferredFont(forTextStyle: .callout),
//                    .foregroundColor: NSColor.tertiaryLabelColor]))
//            }
            self.string = .init(string)
            
            let height = CTFramesetterSuggestFrameSizeWithConstraints(
                CTFramesetterCreateWithAttributedString(self.string),
                CFRange(),
                nil,
                .init(width: CGFloat(230),
                      height: .greatestFiniteMagnitude),
                nil)
                .height
            
            rect = .init(x: 0, y: y, width: 280, height: ceil(height) + 30)
            self.item = item
        }
        
        func hash(into: inout Hasher) {
            into.combine(item)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.item == rhs.item
        }
    }
}
