import Combine
import CloudKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let provider = CurrentValueSubject<Provider?, Never>(nil)
    let item = CurrentValueSubject<Item?, Never>(nil)
    let sidebar: CurrentValueSubject<Bool, Never>
    let middlebar: CurrentValueSubject<Bool, Never>
    
    init() {
        sidebar = .init(UserDefaults.standard.value(forKey: "sidebar") as? Bool ?? true)
        middlebar = .init(UserDefaults.standard.value(forKey: "middlebar") as? Bool ?? true)
    }
}
