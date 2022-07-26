import StoreKit

extension App {
    final class Delegate: NSObject, UIApplicationDelegate, SKPaymentTransactionObserver {
        weak var session: Session?
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            SKPaymentQueue.default().add(self)
            application.registerForRemoteNotifications()
            return true
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
            await session?.cloud.notified == true ? .newData : .noData
        }
        
        func paymentQueue(_: SKPaymentQueue, shouldAddStorePayment: SKPayment, for product: SKProduct) -> Bool {
            Task
                .detached {
                    await self.session?.store.purchase(legacy: product)
                }
            return false
        }
        
        func paymentQueue(_: SKPaymentQueue, updatedTransactions: [SKPaymentTransaction]) {
    
        }
    }
}
