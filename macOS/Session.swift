import Combine
import CloudKit
import Archivable
import News

final class Session {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let provider = CurrentValueSubject<Provider?, Never>(nil)
    let item = PassthroughSubject<Item?, Never>()
    let sidebar = PassthroughSubject<Void, Never>()
    let middlebar = PassthroughSubject<Void, Never>()
}
