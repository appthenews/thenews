import AppKit
import Combine

final class Topbar: NSView {
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        super.init(frame: .zero)
        
        let split3 = NSImage(systemSymbolName: "rectangle.split.3x1", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))) ?? .init()
        
        let split2 = NSImage(systemSymbolName: "rectangle.split.2x1", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))) ?? .init()
        
        let split1 = NSImage(systemSymbolName: "square", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: .secondaryLabelColor))) ?? .init()
         
        let segmented = NSSegmentedControl(images: [split3, split2, split1],
                                         trackingMode: .selectOne,
                                         target: self,
                                         action: #selector(change))
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.selectedSegment = session.columns.value
        segmented.isHidden = true
        addSubview(segmented)
        
        let delete = Button(symbol: "trash")
        delete.state = .hidden
        delete.toolTip = "Delete article"
        delete
            .click
            .sink {
                session.trash.send()
            }
            .store(in: &subs)
        addSubview(delete)
        
        let share = Button(symbol: "square.and.arrow.up")
        share.state = .hidden
        share.toolTip = "Share article"
        share
            .click
            .sink {
                guard
                    let link = session.item.value?.link,
                    let url = URL(string: link)
                else { return }
                
                share.menu = .init()
                share.menu!.items = [
                    Menu.Link(link: link),
                    .separator(),
                    Menu.Share(title: "To Service...", url: url)]
                
                share.menu!.popUp(positioning: nil, at: .init(x: 0, y: -8), in: share)
            }
            .store(in: &subs)
        addSubview(share)
        
        let bookmark = Button(symbol: "bookmark")
        bookmark.state = .hidden
        bookmark
            .click
            .sink {
                guard let item = session.item.value else { return }
                Task {
                    if item.status == .bookmarked {
                        await session.cloud.unbookmark(item: item)
                    } else {
                        await session.cloud.bookmark(item: item)
                    }
                }
            }
            .store(in: &subs)
        addSubview(bookmark)
        
//        let open = Button(symbol: "paperplane")
//        open.state = .hidden
//        open.toolTip = "Continue reading"
//        open
//            .click
//            .subscribe(session.open)
//            .store(in: &subs)
//        addSubview(open)
        
        segmented.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 7).isActive = true
        delete.rightAnchor.constraint(equalTo: bookmark.leftAnchor, constant: -14).isActive = true
        bookmark.rightAnchor.constraint(equalTo: share.leftAnchor, constant: -14).isActive = true
        share.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
//        open.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        [segmented, delete, share, bookmark]
            .forEach {
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        session
            .item
            .removeDuplicates()
            .sink { item in
                bookmark.toolTip = item?.status == .bookmarked ? "Remove bookmark" : "Add bookmark"
                
                if let item = item {
                    delete.state = .on
                    share.state = .on
                    bookmark.state = .on
//                    open.state = .on
                    
                    bookmark.image.image = .init(systemSymbolName: item.status == .bookmarked ? "bookmark.fill" : "bookmark",
                                                 accessibilityDescription: nil)
                } else {
                    delete.state = .hidden
                    share.state = .hidden
                    bookmark.state = .hidden
//                    open.state = .hidden
                }
            }
            .store(in: &subs)
        
        session
            .loading
            .filter {
                !$0
            }
            .sink { _ in
                segmented.isHidden = false
            }
            .store(in: &subs)
        
        session
            .reader
            .sink { reader in
                [delete, share, bookmark]
                    .forEach {
                        $0.color = reader ? .init(named: "Text")! : .controlAccentColor
                    }
            }
            .store(in: &subs)
    }
    
    @objc private func change(_ segmented: NSSegmentedControl) {
        guard session.columns.value != segmented.selectedSegment else { return }
        session.columns.value = segmented.selectedSegment
        UserDefaults.standard.set(segmented.selectedSegment, forKey: "columns")
    }
}
