import AppKit

extension Menu {
    final class Link: NSMenuItem {
        private let link: String
        
        required init(coder: NSCoder) { fatalError() }
        init(link: String) {
            self.link = link
            
            super.init(title: "Copy Link", action: nil, keyEquivalent: "")
            target = self
            action = #selector(share)
            image = .init(systemSymbolName: "link", accessibilityDescription: nil)
        }
        
        @objc private func share() {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(link, forType: .string)
        }
    }
}
