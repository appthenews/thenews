import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let rect: CGRect
        
        init(item: Item, y: CGFloat) {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byWordWrapping
            paragraph.lineBreakStrategy = .pushOut
            paragraph.alignment = .justified
            paragraph.allowsDefaultTighteningForTruncation = false
            paragraph.tighteningFactorForTruncation = 0
            paragraph.usesDefaultHyphenation = false
            paragraph.defaultTabInterval = 0
            paragraph.hyphenationFactor = 0
            
            let fontProvider = NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .footnote).pointSize,
                weight: .regular)
            
            let attributesProvider = AttributeContainer([
                .font: fontProvider,
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraph])
            
            let fontDate = NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .footnote).pointSize,
                weight: .light)
            
            let attributesDate = AttributeContainer([
                .font: fontDate,
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraph])
            
            let fontTitle = NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize,
                weight: .regular)
            
            let attributesTitle = AttributeContainer([
                .font: fontTitle,
                .foregroundColor: NSColor.labelColor,
                .paragraphStyle: paragraph])
            
            var string = AttributedString(item.feed.provider.title, attributes: attributesProvider)
            string.append(AttributedString(" — ", attributes: attributesDate))
            string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                         unitsStyle: .wide)),
                                           attributes: attributesDate))
            string.append(AttributedString("\n", attributes: attributesTitle))
            string.append(AttributedString(item.title, attributes: attributesTitle))
            self.string = .init(string)
            
            let height = CTFramesetterSuggestFrameSizeWithConstraints(
                CTFramesetterCreateWithAttributedString(self.string),
                CFRange(),
                nil,
                .init(width: 230,
                      height: CGFloat.greatestFiniteMagnitude),
                nil)
                .height
            
            rect = .init(x: 0, y: y, width: 290, height: ceil(height) + 30)
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
