import AppKit
import News

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    private let session = Session()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu(session: session)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        registerForRemoteNotifications()
        Window(session: self.session).makeKeyAndOrderFront(nil)
        
        session.cloud.ready.notify(queue: .main) {
            Defaults.start()
            
            Task
                .detached {
                    await self.session.store.launch()
                }
        }
    }
    
    func applicationDidBecomeActive(_: Notification) {
        session.cloud.pull.send()
        
        session.cloud.ready.notify(queue: .main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Task {
                    await self.session.cloud.fetch()
                
                    if self.session.loading.value {
                        self.session.loading.value = false
                        
                        if await self.session.cloud.model.preferences.providers.isEmpty {
                            self.showPreferencesWindow(nil)
                        }
                    }
                }
            }
        }
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
        session.cloud.pull.send()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
        (anyWindow() ?? Preferences(session: session))
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showSponsor(_ sender: Any?) {
        (anyWindow() ?? Sponsor(session: session))
            .makeKeyAndOrderFront(nil)
    }
}
