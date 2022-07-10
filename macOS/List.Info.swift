import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let rect: CGRect
        
        init(item: Item, y: CGFloat) {
            let fontProvider = NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .footnote).pointSize,
                weight: .regular)
            
            let paragraphProvider = NSMutableParagraphStyle()
            paragraphProvider.lineBreakMode = .byCharWrapping
            
            let attributesProvider = AttributeContainer([
                .font: fontProvider,
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraphProvider])
            
            let fontDate = NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .footnote).pointSize,
                weight: .light)
            
            let paragraphDate = NSMutableParagraphStyle()
            paragraphDate.lineBreakMode = .byCharWrapping
            
            let attributesDate = AttributeContainer([
                .font: fontDate,
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraphDate])
            
            let fontTitle = NSFont.systemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize,
                weight: .regular)
            
            let paragraphTitle = NSMutableParagraphStyle()
            paragraphTitle.lineBreakMode = .byWordWrapping
            paragraphTitle.lineBreakStrategy = .standard
            paragraphTitle.alignment = .left
            paragraphTitle.allowsDefaultTighteningForTruncation = false
            paragraphTitle.tighteningFactorForTruncation = 0
            paragraphTitle.usesDefaultHyphenation = false
            paragraphTitle.defaultTabInterval = 0
            paragraphTitle.baseWritingDirection = .leftToRight
            paragraphTitle.hyphenationFactor = 0
            paragraphTitle.headerLevel = 0
            
            let attributesTitle = AttributeContainer([
                .font: fontTitle,
                .foregroundColor: NSColor.labelColor,
                .paragraphStyle: paragraphTitle,
                .kern: 0,
                .ligature: 0,
                .tracking: 0,
                .baselineOffset: 0,
                .obliqueness: 0,
                .expansion: 0,
                .verticalGlyphForm: 0,
                .markedClauseSegment: 0,
                .spellingState: 0,
                .superscript: 0])
            
            var string = AttributedString(item.feed.provider.title, attributes: attributesProvider)
            string.append(AttributedString(" — ", attributes: attributesDate))
            string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                         unitsStyle: .wide)),
                                           attributes: attributesDate))
            string.append(AttributedString("\n", attributes: attributesTitle))
            string.append(AttributedString(item.title, attributes: attributesTitle))

            self.string = .init(string)
            var range: CFRange! = .init()

            let width = CTFramesetterSuggestFrameSizeWithConstraints(
                CTFramesetterCreateWithAttributedString(self.string),
                CFRange(),
                nil,
                .init(width: 229,
                      height: CGFloat.greatestFiniteMagnitude),
                nil)
                .width
            let height = CTFramesetterSuggestFrameSizeWithConstraints(
                CTFramesetterCreateWithAttributedString(self.string),
                CFRange(),
                nil,
                .init(width: 230,
                      height: CGFloat.greatestFiniteMagnitude),
                nil)
                .height
//            print(size.width)
            
            
//            if item.title.localizedCaseInsensitiveContains("Anthony") {
//                print(item.title)
                print(height)
//                print(range!.length.formatted() + " : " + self.string.string.count.formatted())
//            }
            
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
