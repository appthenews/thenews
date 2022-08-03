import WatchKit

extension App {
    final class Delegate: NSObject, WKExtensionDelegate {
        weak var session: Session?
        
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
            await session?.cloud.notified == true ? .newData : .noData
        }
        
        func didRegisterForRemoteNotifications(withDeviceToken: Data) {
            
        }
        
        func didFailToRegisterForRemoteNotificationsWithError(_: Error) {
            
        }
    }
}
