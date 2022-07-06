import Foundation
import Archivable

struct History: Storable {
    let ids: Set<String>
    let items: Set<Item>
    let synched: Date
    
    var data: Data {
        .init()
        .adding(collection: UInt32.self, strings: UInt8.self, items: ids)
        .adding(size: UInt16.self, collection: items)
        .adding(synched)
    }
    
    init(data: inout Data) {
        ids = .init(data.items(collection: UInt32.self, strings: UInt8.self))
        items = .init(data.collection(size: UInt16.self))
        synched = data.date()
    }
    
    init() {
        ids = []
        items = []
        synched = .init(timestamp: 0)
    }
    
    init(ids: Set<String>, items: Set<Item>, synched: Date) {
        self.ids = ids
        self.items = items
        self.synched = synched
    }
}
