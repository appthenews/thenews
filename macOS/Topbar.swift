import AppKit

final class Topbar: NSView {
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        
        let sidebar = Button(symbol: "sidebar.left")
        addSubview(sidebar)
        
        let middlebar = Button(symbol: "sidebar.squares.left")
        addSubview(middlebar)
        
        let delete = Button(symbol: "trash")
        addSubview(delete)
        
        let share = Button(symbol: "square.and.arrow.up")
        addSubview(share)
        
        let bookmark = Button(symbol: "bookmark")
        addSubview(bookmark)
        
        let open = Button(symbol: "paperplane")
        addSubview(open)
        
        sidebar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        middlebar.leftAnchor.constraint(equalTo: sidebar.rightAnchor, constant: 18).isActive = true
        delete.rightAnchor.constraint(equalTo: share.leftAnchor, constant: -18).isActive = true
        share.rightAnchor.constraint(equalTo: bookmark.leftAnchor, constant: -18).isActive = true
        bookmark.rightAnchor.constraint(equalTo: open.leftAnchor, constant: -18).isActive = true
        open.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        
        [sidebar, middlebar, delete, share, bookmark, open]
            .forEach {
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
    }
}
