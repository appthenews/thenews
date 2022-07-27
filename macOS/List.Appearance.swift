import AppKit

extension List {
    struct Appearance {
        var provider = NSFont.preferredFont(forTextStyle: .body)
        var date = NSFont.preferredFont(forTextStyle: .footnote)
        var title = NSFont.preferredFont(forTextStyle: .footnote)
        var primary = NSColor.labelColor
        var secondary = NSColor.secondaryLabelColor
        var tertiary = NSColor.tertiaryLabelColor
        let paragraph: NSParagraphStyle
        let spacing = NSAttributedString(string: "\n\n", attributes: [.font: NSFont.systemFont(ofSize: 4, weight: .regular)])
        
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
    }
}
