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
        
        if session.loading.value {
            session.cloud.ready.notify(queue: .main) {
                self.session.loading.value = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Task {
                        if await self.session.cloud.model.preferences.providers.isEmpty {
                            self.showPreferencesWindow(nil)
                        }
                        
                        await self.session.cloud.fetch()
                    }
                }
            }
        } else {
            Task {
                await session.cloud.fetch()
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
