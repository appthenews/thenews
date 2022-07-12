import Combine
import CloudKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let provider = CurrentValueSubject<Provider?, Never>(.all)
    let item = CurrentValueSubject<Item?, Never>(nil)
    let columns: CurrentValueSubject<Int, Never>
    
    init() {
        columns = .init(UserDefaults.standard.value(forKey: "columns") as? Int ?? 2)
    }
}
