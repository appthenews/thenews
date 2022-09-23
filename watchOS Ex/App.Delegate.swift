import WatchKit

extension App {
    final class Delegate: NSObject, WKApplicationDelegate {
        weak var session: Session?
        
        func applicationDidFinishLaunching() {
            WKApplication.shared().registerForRemoteNotifications()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
            await session?.cloud.notified == true ? .newData : .noData
        }
    }
}
