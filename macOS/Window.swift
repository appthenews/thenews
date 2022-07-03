import AppKit
import Combine

final class Window: NSWindow {
    private weak var content: NSVisualEffectView!
    private var subs = Set<AnyCancellable>()
    private let session = Session()
    
    init() {
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: 800,
                                      height: 500),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 520, height: 200)
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
        
        let content = NSVisualEffectView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.state = .active
        content.material = .menu
        contentView!.addSubview(content)
        self.content = content
        
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
    
    private func place(view: NSView) {
        content
            .subviews
            .forEach {
                $0.removeFromSuperview()
            }
        
        content.addSubview(view)
        makeFirstResponder(view)

        view.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
    }
}
