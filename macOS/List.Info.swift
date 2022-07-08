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
            rect = .init(x: 0, y: y, width: 100, height: 100)
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
