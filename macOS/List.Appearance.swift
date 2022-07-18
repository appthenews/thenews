import AppKit

extension List {
    struct Appearance {
        var provider: AttributeContainer
        var date: AttributeContainer
        var title: AttributeContainer
        
        init() {
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byWordWrapping
            paragraph.lineBreakStrategy = .pushOut
            paragraph.allowsDefaultTighteningForTruncation = false
            paragraph.tighteningFactorForTruncation = 0
            paragraph.usesDefaultHyphenation = false
            paragraph.defaultTabInterval = 0
            paragraph.hyphenationFactor = 0
            
            provider = .init([.paragraphStyle: paragraph])
            date = .init([.paragraphStyle: paragraph])
            title = .init([.paragraphStyle: paragraph])
        }
    }
}
