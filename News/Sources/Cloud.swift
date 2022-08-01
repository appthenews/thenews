import Archivable

extension Cloud where Output == Archive {
    public func fetch() async {
        do {
            let fetchable = model.fetchable
            
            if !fetchable.isEmpty {
                var index = 0
                model.fetch = .on(.init(index) / .init(fetchable.count))
                await publish(model: model)
                
                model.clean()
                
                let fetcher = Fetcher()
                for feed in fetchable {
                    index += 1
                    model.fetch = .on(.init(index) / .init(fetchable.count))
                    await publish(model: model)
                    
                    model.update(feed: feed, date: .now, items: try await fetcher.fetch(feed: feed))
                }
                
                model.fetch = .off
                await stream()
            }
        } catch { }
    }
    
    public func toggle(feed: Feed, value: Bool) async {
        guard model.preferences.feeds[feed] != value else { return }
        model.preferences.feeds[feed] = value
        await fetch()
        await stream()
    }
    
    public func fetch(interval: Interval) async {
        guard model.preferences.fetch != interval else { return }
        model.preferences.fetch = interval
        
        await fetch()
        await stream()
    }
    
    public func clean(interval: Interval) async {
        guard model.preferences.clean != interval else { return }
        model.preferences.clean = interval
        await stream()
    }
    
    public func read(item: Item) async {
        if item.status == .new {
            model.items = model
                .items
                .removing(item)
                .inserting(item.read)
        }
        
        model.history = .init((item.link + model
            .history
            .filter { recent in
                if recent != item.link,
                   let element = model.items.first(where: { $0.link == recent }) {
                    return model.preferences.feeds[element.feed] ?? false
                }
                return false
            })
        .prefix(30))
        
        await stream()
    }
    
    public func bookmark(item: Item) async {
        guard item.status != .bookmarked else { return }
        model.items = model
            .items
            .filter {
                $0.link != item.link
            }
            .inserting(item.bookmarked)
        await stream()
    }
    
    public func unbookmark(item: Item) async {
        guard item.status == .bookmarked else { return }
        model.items = model
            .items
            .filter {
                $0.link != item.link
            }
            .inserting(item.read)
        await stream()
    }
    
    public func delete(item: Item) async {
        model.items = model
            .items
            .filter {
                $0.link != item.link
            }
        await stream()
    }
    
    public func clear() async {
        guard !model.history.isEmpty else { return }
        model.history = []
        await stream()
    }
}
