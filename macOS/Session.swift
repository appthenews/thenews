import Combine
import CloudKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let search = CurrentValueSubject<_, Never>("")
    let provider: CurrentValueSubject<Provider?, Never>
    let item: CurrentValueSubject<Item?, Never>
    let columns: CurrentValueSubject<Int, Never>
    let showing: CurrentValueSubject<Int, Never>
    let items: AnyPublisher<[Item], Never>
    private var subs = Set<AnyCancellable>()
    
    init() {
        let item = CurrentValueSubject<Item?, Never>(nil)
        let provider = CurrentValueSubject<Provider?, Never>(.all)
        columns = .init(UserDefaults.standard.value(forKey: "columns") as? Int ?? 0)
        showing = .init(UserDefaults.standard.value(forKey: "showing") as? Int ?? 0)
        items = provider
            .removeDuplicates()
            .combineLatest(cloud) { provider, model in
                provider == nil
                ? []
                : model
                    .items(provider: provider!)
            }
            .removeDuplicates()
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
                .eraseToAnyPublisher()
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
    }
}
