import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let rect: CGRect
        
        init(item: Item, y: CGFloat) {
            let fontProvider = NSFont.monospacedDigitSystemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize,
                weight: .regular)
            
            let paragraphProvider = NSMutableParagraphStyle()
            paragraphProvider.lineSpacing = 0
            print(fontProvider.leading)
            
            let attributesProvider = AttributeContainer([
                .font: fontProvider,
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraphProvider])
            
            let fontDate = NSFont.monospacedDigitSystemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize,
                weight: .light)
            
            let paragraphDate = NSMutableParagraphStyle()
            paragraphDate.lineSpacing = 0
            
            let attributesDate = AttributeContainer([
                .font: fontDate,
                .foregroundColor: NSColor.secondaryLabelColor,
                .paragraphStyle: paragraphDate])
            
            let fontTitle = NSFont.monospacedDigitSystemFont(
                ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize,
                weight: .regular)
            
            print(fontTitle.leading)
            
            let paragraphTitle = NSMutableParagraphStyle()
//            paragraphTitle.
            
            let attributesTitle = AttributeContainer([
                .font: fontTitle,
                .foregroundColor: NSColor.labelColor,
                .paragraphStyle: paragraphTitle])
            
            var string = AttributedString(item.feed.provider.title, attributes: attributesProvider)
            string.append(AttributedString(" — ", attributes: attributesDate))
            string.append(AttributedString(item.date.formatted(.relative(presentation: .named,
                                                                         unitsStyle: .wide)),
                                           attributes: attributesDate))
            string.append(AttributedString("\n", attributes: attributesTitle))
            string.append(AttributedString(item.title, attributes: attributesTitle))
            string.append(AttributedString("       ", attributes: attributesTitle))

            self.string = .init(string)
            
            let height = CTFramesetterSuggestFrameSizeWithConstraints(
                CTFramesetterCreateWithAttributedString(self.string),
                .init(location: 0, length: 0),
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
