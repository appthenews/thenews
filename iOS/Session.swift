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
    
    @Published var font: Double {
        didSet {
            UserDefaults.standard.setValue(font, forKey: "font")
        }
    }
    
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
    
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
