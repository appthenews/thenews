import Foundation
import CloudKit
import Archivable
import News

final class Session: ObservableObject {
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    let store = Store()
}
