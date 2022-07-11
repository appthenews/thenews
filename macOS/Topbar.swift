import AppKit
import Combine

final class Topbar: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        
        let sidebar = Button(symbol: "sidebar.left")
        sidebar
            .click
            .sink {
                session.sidebar.value.toggle()
            }
            .store(in: &subs)
        addSubview(sidebar)
        
        let middlebar = Button(symbol: "sidebar.squares.left")
        middlebar
            .click
            .sink {
                session.middlebar.value.toggle()
            }
            .store(in: &subs)
        addSubview(middlebar)
        
        let delete = Button(symbol: "trash")
        addSubview(delete)
        
        let share = Button(symbol: "square.and.arrow.up")
        addSubview(share)
        
        let bookmark = Button(symbol: "bookmark")
        addSubview(bookmark)
        
        let open = Button(symbol: "paperplane")
        addSubview(open)
        
        delete.rightAnchor.constraint(equalTo: share.leftAnchor, constant: -18).isActive = true
        share.rightAnchor.constraint(equalTo: bookmark.leftAnchor, constant: -18).isActive = true
        bookmark.rightAnchor.constraint(equalTo: open.leftAnchor, constant: -18).isActive = true
        open.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        
        let leftSidebar = sidebar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 0)
        leftSidebar.isActive = true
        
        let leftMiddlebar = middlebar.leftAnchor.constraint(equalTo: sidebar.rightAnchor, constant: 0)
        leftMiddlebar.isActive = true
        
        [sidebar, middlebar, delete, share, bookmark, open]
            .forEach {
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        var first = true
        
        session
            .sidebar
            .sink {
                leftSidebar.constant = $0 ? 65 : 5
                leftMiddlebar.constant = $0 ? 18 : 5
                
                if !first {
                    NSAnimationContext
                        .runAnimationGroup {
                            $0.allowsImplicitAnimation = true
                            $0.duration = 0.3
                            $0.timingFunction = .init(name: .easeInEaseOut)
                            self.layoutSubtreeIfNeeded()
                        }
                }
                
                first = false
            }
            .store(in: &subs)
    }
}
