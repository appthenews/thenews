import AppKit

final class Window: NSWindow {
    private let session: Session
    
    init(session: Session) {
        self.session = session
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: 800,
                                      height: 500),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 600, height: 280)
        center()
        toolbar = .init()
        isReleasedWhenClosed = false
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Topbar(session: session)
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        let sidebar = Sidebar(session: session)
        contentView!.addSubview(sidebar)
        
        let middlebar = Middlebar(session: session)
        contentView!.addSubview(middlebar)
        
        let content = Content(session: session)
        contentView!.addSubview(content)
        
        sidebar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        
        middlebar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        middlebar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        middlebar.leftAnchor.constraint(equalTo: sidebar.rightAnchor).isActive = true
        
        content.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: middlebar.rightAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
    }
}
