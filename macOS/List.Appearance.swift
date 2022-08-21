import AppKit

extension List {
    struct Appearance {
        var title = NSFont.preferredFont(forTextStyle: .footnote)
        var primary = NSColor.labelColor
        var secondary = NSColor.secondaryLabelColor
        var tertiary = NSColor.tertiaryLabelColor
        var text = NSColor.labelColor
        var reader = false
        let provider = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular)
        let date = NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .light)
        let paragraph: NSParagraphStyle
        let spacing = NSAttributedString(string: "\n\n", attributes: [.font: NSFont.systemFont(ofSize: 5, weight: .regular)])
        
        init() {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byWordWrapping
            paragraph.lineBreakStrategy = .pushOut
            paragraph.allowsDefaultTighteningForTruncation = false
            paragraph.tighteningFactorForTruncation = 0
            paragraph.usesDefaultHyphenation = false
            paragraph.defaultTabInterval = 0
            paragraph.hyphenationFactor = 0
            paragraph.lineSpacing = 1
            paragraph.minimumLineHeight = 1
            paragraph.maximumLineHeight = 100
            self.paragraph = paragraph
        }
        
        func heading(new: Bool) -> NSColor {
            new
            ? reader ? text : secondary
            : tertiary
        }
        
        func content(new: Bool) -> NSColor {
            new
            ? reader ? text : primary
            : tertiary
        }
    }
}
