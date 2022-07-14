import AppKit

final class Preferences: NSWindow {
    init(session: Session) {
        let controller = NSTabViewController()
        controller.tabStyle = .toolbar
        
        super.init(contentRect: .zero,
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        
        controller.tabViewItems = [
            item(Feeds(session: session), title: "Feeds", symbol: "switch.2"),
            item(Update(session: session), title: "Update", symbol: "calendar.badge.clock")]
        animationBehavior = .alertPanel
        isReleasedWhenClosed = false
        isMovableByWindowBackground = true
        titlebarAppearsTransparent = true
        contentViewController = controller
        center()
        setFrameAutosaveName("Preferences")
    }
    
    private func item(_ content: NSVisualEffectView, title: String, symbol: String) -> NSTabViewItem {
        content.state = .active
        content.material = .menu
        
        let item = NSTabViewItem()
        item.label = title
        item.toolTip = title
        item.image = .init(systemSymbolName: symbol, accessibilityDescription: nil)
        item.viewController = .init()
        item.viewController!.view = content
        item.viewController!.preferredContentSize = content.frame.size
        
        return item
    }
}
