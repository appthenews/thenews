import Combine
import CloudKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let provider = CurrentValueSubject<Provider?, Never>(.all)
    let item = CurrentValueSubject<Item?, Never>(nil)
    let search = CurrentValueSubject<_, Never>("")
    let columns: CurrentValueSubject<Int, Never>
    let showing: CurrentValueSubject<Int, Never>
    let items: AnyPublisher<[Item], Never>
    
    init() {
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
                        .filter { item in
                            switch showing {
                            case 0:
                                return true
                            case 1:
                                return item.status == .new
                            default:
                                return item.status == .bookmarked
                            }
                        }
                        .filter(search: search)
                        .sorted()
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
