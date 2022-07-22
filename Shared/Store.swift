import StoreKit
import Combine
import News

final actor Store {
    enum Status: Equatable {
        case
        loading,
        ready,
        error(String)
    }
    
    enum Item: String, CaseIterable {
        case
        sponsor = "thenewsapp.sponsor"
    }
    
    nonisolated let status = CurrentValueSubject<Status, Never>(.ready)
    nonisolated let purchased = PassthroughSubject<Void, Never>()
    private var products = [Item : Product]()
    private var restored = false
    
    func launch() async {
        for await result in Transaction.updates {
            if case let .verified(safe) = result {
                await process(transaction: safe)
            }
        }
    }
    
    func load(item: Item) async -> Product? {
        guard let product = products[item] else {
            guard let product = try? await Product.products(for: [item.rawValue]).first else { return nil }
            products[item] = product
            return product
        }
        return product
    }
    
    func purchase(_ product: Product) async {
        status.send(.loading)

        do {
            switch try await product.purchase() {
            case let .success(verification):
                if case let .verified(safe) = verification {
                    await process(transaction: safe)
                    status.send(.ready)
                } else {
                    status.send(.error("Purchase verification failed."))
                }
            case .pending:
                status.send(.error("Purchase is pending..."))
            default:
                status.send(.ready)
            }
        } catch let error as StoreKitError {
            switch error {
            case .userCancelled:
                break
            case .notEntitled:
                status.send(.error("Can't purchase at this moment"))
            case .notAvailableInStorefront:
                status.send(.error("Product not available"))
            case let .networkError(error):
                status.send(.error(error.localizedDescription))
            case let .systemError(error):
                status.send(.error(error.localizedDescription))
            default:
                status.send(.error("Unknown error, try again later"))
            }
        } catch let error {
            status.send(.error(error.localizedDescription))
        }
    }
    
    func restore() async {
        status.send(.loading)
        
        if restored {
            try? await AppStore.sync()
        }
        
        for await result in Transaction.currentEntitlements {
            if case let .verified(safe) = result {
                await process(transaction: safe)
            }
        }
        
        status.send(.ready)
        restored = true
    }
    
    func purchase(legacy: SKProduct) async {
        guard let product = try? await Product.products(for: [legacy.productIdentifier]).first else { return }
        await purchase(product)
    }
    
    private func process(transaction: Transaction) async {
        guard
            let item = Item(rawValue: transaction.productID),
            item == .sponsor
        else { return }
        
        if transaction.revocationDate == nil {
            Defaults.sponsor = true
            
            DispatchQueue.main.async { [weak self] in
                self?.purchased.send()
            }
        } else {
            Defaults.sponsor = false
        }
        
        await transaction.finish()
    }
}
