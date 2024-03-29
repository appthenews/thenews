import Combine
import CloudKit
import StoreKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
    let loading = CurrentValueSubject<_, Never>(true)
    let search = CurrentValueSubject<_, Never>("")
    let up = PassthroughSubject<Void, Never>()
    let down = PassthroughSubject<Void, Never>()
    let open = PassthroughSubject<Void, Never>()
    let trash = PassthroughSubject<Void, Never>()
    let find = PassthroughSubject<Void, Never>()
    let provider: CurrentValueSubject<Provider?, Never>
    let item: CurrentValueSubject<Item?, Never>
    let columns: CurrentValueSubject<Int, Never>
    let showing: CurrentValueSubject<Int, Never>
    let font: CurrentValueSubject<CGFloat, Never>
    let reader: CurrentValueSubject<Bool, Never>
    let froob: CurrentValueSubject<Bool, Never>
    let items = PassthroughSubject<[Item], Never>()
    private var reviewed = false
    private var subs = Set<AnyCancellable>()
    
    init() {
        let item = CurrentValueSubject<Item?, Never>(nil)
        let provider = CurrentValueSubject<Provider?, Never>(.init(
            rawValue: UserDefaults.standard.value(forKey: "provider") as? UInt8 ?? 0)!)
        
        columns = .init(UserDefaults.standard.value(forKey: "columns") as? Int ?? 0)
        showing = .init(UserDefaults.standard.value(forKey: "showing") as? Int ?? 0)
        font = .init(UserDefaults.standard.value(forKey: "font") as? CGFloat ?? 2)
        reader = .init(UserDefaults.standard.value(forKey: "reader") as? Bool ?? false)
        froob = .init(Defaults.froob)
        self.item = item
        self.provider = provider
        
        items
            .sink { items in
                if let current = item.value {
                    if let new = items.first(where: { $0.link == current.link }) {
                        if new.status != current.status {
                            item.value = new
                        }
                    } else {
                        item.value = nil
                    }
                }
            }
            .store(in: &subs)
        
        cloud
            .filter {
                $0.timestamp > 0
            }
            .map(\.preferences.providers)
            .removeDuplicates()
            .sink { providers in
                if let current = provider.value,
                   current != .all,
                   !providers.contains(current) {
                    provider.value = nil
                }
            }
            .store(in: &subs)
        
        open
            .sink {
                guard
                    let link = item.value?.link,
                    let url = URL(string: link)
                else { return }
                NSWorkspace.shared.open(url)
            }
            .store(in: &subs)
        
        down
            .map { Void -> Date in
                Date.now
            }
            .combineLatest(items)
            .removeDuplicates {
                $0.0 == $1.0
            }
            .sink { [weak self] _, items in
                if let current = item.value?.link {
                    items
                        .firstIndex {
                            $0.link == current
                        }
                        .map { index in
                            let item = items[index < items.count - 1 ? index + 1 : 0]
                            
                            Task { [weak self] in
                                await self?.read(item: item)
                            }
                        }
                } else if let item = items.first {
                    Task { [weak self] in
                        await self?.read(item: item)
                    }
                }
            }
            .store(in: &subs)
        
        up
            .map { Void -> Date in
                Date.now
            }
            .combineLatest(items)
            .removeDuplicates {
                $0.0 == $1.0
            }
            .sink { [weak self] _, items in
                if let current = item.value?.link {
                    items
                        .firstIndex {
                            $0.link == current
                        }
                        .map { index in
                            let item = items[index > 0 ? index - 1 : items.count - 1]
                            
                            Task { [weak self] in
                                await self?.read(item: item)
                            }
                        }
                } else if let item = items.last {
                    Task { [weak self] in
                        await self?.read(item: item)
                    }
                }
            }
            .store(in: &subs)
        
        trash
            .sink { [weak self] in
                guard let item = item.value else { return }
                
                let alert = NSAlert()
                alert.alertStyle = .warning
                alert.icon = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                alert.messageText = "Delete article?"
                
                let delete = alert.addButton(withTitle: "Delete")
                let cancel = alert.addButton(withTitle: "Cancel")
                delete.keyEquivalent = "\r"
                cancel.keyEquivalent = "\u{1b}"
                
                if alert.runModal().rawValue == delete.tag {
                    Task { [weak self] in
                        await self?.cloud.delete(item: item)
                    }
                }
            }
            .store(in: &subs)
        
        store
            .purchased
            .sink { [weak self] in
                self?.froob.value = false
                ((NSApp as! App).anyWindow() ?? Purchased())
                    .makeKeyAndOrderFront(nil)
            }
            .store(in: &subs)
        
        provider
            .removeDuplicates()
            .combineLatest(cloud) { provider, model in
                provider == nil
                ? []
                : model
                    .items(provider: provider!)
            }
            .combineLatest(search
                .removeDuplicates(),
                           showing
                .removeDuplicates()) { items, search, showing in
                    items
                        .filter { element in
                            switch showing {
                            case 0:
                                return true
                            case 1:
                                return element.status == .new || element.link == item.value?.link
                            default:
                                return element.status == .bookmarked
                            }
                        }
                        .filter(search: search)
                        .sorted()
                }
                .removeDuplicates()
                .sink { [weak self] in
                    self?.items.send($0)
                }
                .store(in: &subs)
    }
    
    @MainActor func read(item: Item) async {
        self.item.value = item
        await cloud.read(item: item)
        
        #if !DEBUG
        if Defaults.ready && !reviewed {
            SKStoreReviewController.requestReview()
            reviewed = true
        }
        #endif
    }
}
