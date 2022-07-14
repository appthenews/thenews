import Archivable

extension Cloud where Output == Archive {
    public func fetch() async {
        do {
            let fetchable = model.fetchable
            
            if !fetchable.isEmpty {
                model.clean()
                
                let fetcher = Fetcher()
                for feed in fetchable {
                    let result = try await fetcher.fetch(feed: feed, synched: model.ids)
                    model.update(feed: feed, date: .now, ids: result.ids, items: result.items)
                }
                
                await stream()
            }
        } catch { }
    }
    
    public func toggle(feed: Feed, value: Bool) async {
        model.preferences.feeds[feed] = value
        
        await fetch()
        await stream()
    }
    
    public func fetch(interval: Interval) async {
        model.preferences.fetch = interval
        await stream()
    }
    
    public func clean(interval: Interval) async {
        model.preferences.clean = interval
        await stream()
    }
    
    public func read(item: Item) async {
        guard item.status != .read else { return }
        model.items = model
            .items
            .removing(item)
            .inserting(item.read)
        await stream()
    }
    
    public func bookmark(item: Item) async {
        guard item.status != .bookmarked else { return }
        model.items = model
            .items
            .removing(item)
            .inserting(item.bookmarked)
        await stream()
    }
    
    public func delete(item: Item) async {
        model.items = model
            .items
            .removing(item)
        await stream()
    }
}
