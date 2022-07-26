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
    
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
    let previous = PassthroughSubject<Void, Never>()
    let next = PassthroughSubject<Void, Never>()
    
    init() {
        reader = UserDefaults.standard.value(forKey: "reader") as? Bool ?? false
        font = .init(UserDefaults.standard.value(forKey: "font") as? Double ?? 0)
        accent()
    }
    
    private func accent() {
        UINavigationBar.appearance().barTintColor = reader ? .init(named: "Background") : .systemBackground
        UITabBar.appearance().barTintColor = reader ? .init(named: "Background") : .systemBackground
        UITabBar.appearance().unselectedItemTintColor = reader ? .tertiaryLabel : .secondaryLabel
    }
}
