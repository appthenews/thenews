import UIKit
import CloudKit
import StoreKit
import Combine
import Archivable
import News

final class Session: ObservableObject {
    @Published var reader: Bool {
        didSet {
            UserDefaults.standard.setValue(reader, forKey: "reader")
            accent()
        }
    }
    
    @Published var font: Double {
        didSet {
            UserDefaults.standard.setValue(font, forKey: "font")
        }
    }
    
    @Published var showing: Int {
        didSet {
            UserDefaults.standard.setValue(showing, forKey: "showing")
            
            if showing == 0 {
                filters = false
            }
        }
    }
    
    @Published var filters: Bool {
        didSet {
            if !filters && showing != 0 {
                showing = 0
            }
        }
    }
    
    @Published var item: Item? {
        didSet {
            if let item = item {
                Task {
                    await cloud.read(item: item)
                }
            }
        }
    }
    
    @Published var tab = 1
    @Published var provider: Provider?
    @Published var search = ""
    @Published private(set) var articles = [Item]()
    
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
    private var subs = Set<AnyCancellable>()
    
    init() {
        reader = UserDefaults.standard.value(forKey: "reader") as? Bool ?? false
        font = UserDefaults.standard.value(forKey: "font") as? Double ?? 0
        showing = UserDefaults.standard.value(forKey: "showing") as? Int ?? 0
        filters = UserDefaults.standard.value(forKey: "showing") as? Int != 0

        accent()
        
        cloud
            .combineLatest($provider
                .compactMap {
                    $0
                }) { model, provider in
                model.items(provider: provider)
            }
            .removeDuplicates()
            .combineLatest($showing, $search) { items, showing, search in
                items
                    .filter { element in
                        switch showing {
                        case 0:
                            return true
                        case 1:
                            return element.status == .new
                        default:
                            return element.status == .bookmarked
                        }
                    }
                    .filter(search: search)
                    .sorted()
            }
            .removeDuplicates()
            .assign(to: &$articles)
        
        $articles
            .combineLatest($item
                .compactMap {
                    $0
                }) { articles, item in
                    articles
                        .first {
                            $0.link == item.link
                        }
                        .flatMap {
                            item == $0 ? nil : $0
                        }
                }
                .compactMap {
                    $0
                }
                .removeDuplicates()
                .assign(to: &$item)
    }
    
    func previous() {
        if let link = item?.link {
            articles
                .firstIndex {
                    $0.link == link
                }
                .map { index in
                    if index > 0 {
                        item = articles[index - 1]
                    } else {
                        item = articles.last
                    }
                }
        }
    }
    
    func next() {
        if let link = item?.link {
            articles
                .firstIndex {
                    $0.link == link
                }
                .map { index in
                    if index < articles.count - 1 {
                        item = articles[index + 1]
                    } else {
                        item = articles.first
                    }
                }
        }
    }
    
    private func accent() {
        UINavigationBar.appearance().barTintColor = reader ? .init(named: "Background") : .systemBackground
        UITabBar.appearance().barTintColor = reader ? .init(named: "Background") : .systemBackground
        UITabBar.appearance().unselectedItemTintColor = reader ? .tertiaryLabel : .secondaryLabel
    }
}
