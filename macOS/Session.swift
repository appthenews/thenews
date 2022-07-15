import AppKit
import Combine
import CloudKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let search = CurrentValueSubject<_, Never>("")
    let up = PassthroughSubject<Void, Never>()
    let down = PassthroughSubject<Void, Never>()
    let open = PassthroughSubject<Void, Never>()
    let provider: CurrentValueSubject<Provider?, Never>
    let item: CurrentValueSubject<Item?, Never>
    let columns: CurrentValueSubject<Int, Never>
    let showing: CurrentValueSubject<Int, Never>
    let font: CurrentValueSubject<Int, Never>
    let items: AnyPublisher<[Item], Never>
    private var subs = Set<AnyCancellable>()
    
    init() {
        let item = CurrentValueSubject<Item?, Never>(nil)
        let provider = CurrentValueSubject<Provider?, Never>(.init(
            rawValue: UserDefaults.standard.value(forKey: "provider") as? UInt8 ?? 0)!)
        
        columns = .init(UserDefaults.standard.value(forKey: "columns") as? Int ?? 0)
        showing = .init(UserDefaults.standard.value(forKey: "showing") as? Int ?? 0)
        font = .init(UserDefaults.standard.value(forKey: "font") as? Int ?? 4)
        
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
            .sink { _, items in
                if let current = item.value?.link {
                    items
                        .firstIndex {
                            $0.link == current
                        }
                        .map { index in
                            item.value = items[index < items.count - 1 ? index + 1 : 0]
                        }
                } else {
                    item.value = items.first
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
            .sink { _, items in
                if let current = item.value?.link {
                    items
                        .firstIndex {
                            $0.link == current
                        }
                        .map { index in
                            item.value = items[index > 0 ? index - 1 : items.count - 1]
                        }
                } else {
                    item.value = items.last
                }
            }
            .store(in: &subs)
    }
}
