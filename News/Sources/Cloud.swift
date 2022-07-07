import Archivable

extension Cloud where Output == Archive {
    public func fetch() async {
//        do {
//            var fetch: Fetch!
//            for source in model.fetchable {
//                if fetch == nil {
//                    fetch = .init()
//                }
//                
//                let string = try await fetch(source)
//                
//                Swift.debugPrint(string)
//            }
//        } catch { }
//        
        
        let fetcher = Fetcher()
//        try! await Swift.debugPrint(fetcher.fetch(source: .reutersEurope, synched: []))
        let a = try! await fetcher.fetch(source: .theGuardianWorld, synched: [])
        Swift.debugPrint(a.ids.count)
        Swift.debugPrint(a.items.count)
    }
}
