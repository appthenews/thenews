import CloudKit
import Archivable
import News

final class Session: ObservableObject {
    @Published var reader: Bool {
        didSet {
            UserDefaults.standard.setValue(reader, forKey: "reader")
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
        }
    }
    
    @Published var loading = true
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.thenews")
    
    init() {
        let showing = UserDefaults.standard.value(forKey: "showing") as? Int ?? 0
        reader = UserDefaults.standard.value(forKey: "reader") as? Bool ?? false
        font = UserDefaults.standard.value(forKey: "font") as? Double ?? 0
        self.showing = showing
    }
}
