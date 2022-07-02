import AppKit

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
//        mainMenu = Menu()
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        Window().makeKeyAndOrderFront(nil)
    }
}
