import Foundation
import CloudKit
import Archivable
import News
import UIKit

final class Session: ObservableObject {
    @Published var reader: Bool {
        didSet {
            UserDefaults.standard.setValue(reader, forKey: "reader")
            accent()
        }
    }
    
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
    
    init() {
        reader = UserDefaults.standard.value(forKey: "reader") as? Bool ?? false
        accent()
    }
    
    private func accent() {
        UINavigationBar.appearance().barTintColor = reader ? .init(named: "Background") : .systemBackground
        UITabBar.appearance().barTintColor = reader ? .init(named: "Background") : .systemBackground
        UITabBar.appearance().unselectedItemTintColor = reader ? .tertiaryLabel : .secondaryLabel
    }
}
