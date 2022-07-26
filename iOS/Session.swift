import Foundation
import CloudKit
import Archivable
import News

final class Session: ObservableObject {
    @Published var reader: Bool {
        didSet {
            
        }
    }
    
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
    
    init() {
        reader = UserDefaults.standard.value(forKey: "reader") as? Bool ?? false
    }
}
