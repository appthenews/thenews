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
        
        let fetch = Fetch()
        try! await Swift.debugPrint(fetch(.derSpiegelInternational))
    }
}
