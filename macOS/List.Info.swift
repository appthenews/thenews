import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let rect: CGRect
        let first: Bool
        
        init(item: Item, rect: CGRect, first: Bool) {
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
            string = .init()
            self.item = item
            self.rect = rect
            self.first = first
        }
        
        func hash(into: inout Hasher) {
            into.combine(item)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.item == rhs.item
        }
    }
}
