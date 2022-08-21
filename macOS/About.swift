import AppKit
import Coffee
import Combine

final class About: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 460),
                   styleMask: [.titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        backgroundColor = .init(red: 1, green: 0.651, blue: 1, alpha: 1)
        center()
        
        let image = NSImageView(image: .init(named: "Launch")!)
        image.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(image)
        
        let stripe = NSView()
        stripe.translatesAutoresizingMaskIntoConstraints = false
        stripe.wantsLayer = true
        stripe.layer!.backgroundColor = .white
        contentView!.addSubview(stripe)
        
        let title = Text(vibrancy: false)
        title.stringValue = "The News"
        title.font = .systemFont(ofSize: 22, weight: .heavy)
        title.textColor = backgroundColor
        contentView!.addSubview(title)
        
        let version = Text(vibrancy: true)
        version.stringValue = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        version.font = .systemFont(ofSize: 16, weight: .medium)
        version.textColor = .white
        contentView!.addSubview(version)
        
        let location = Text(vibrancy: true)
        location.stringValue = "From Berlin with"
        location.font = .systemFont(ofSize: 12, weight: .regular)
        location.textColor = .white
        contentView!.addSubview(location)
        
        let heart = NSImageView(image: .init(systemSymbolName: "heart.fill", accessibilityDescription: nil) ?? .init())
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.symbolConfiguration = .init(pointSize: 13, weight: .regular)
        heart.contentTintColor = .white
        contentView!.addSubview(heart)
        
        let accept = Control.Prominent(title: "OK")
        accept.color = .white
        accept.text.textColor = .black
        accept
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        contentView!.addSubview(accept)
        
        image.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 40).isActive = true
        
        stripe.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        stripe.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        stripe.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        stripe.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        
        title.centerXAnchor.constraint(equalTo: stripe.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: stripe.topAnchor, constant: 5).isActive = true
        
        version.bottomAnchor.constraint(equalTo: location.topAnchor, constant: -2).isActive = true
        version.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        heart.centerYAnchor.constraint(equalTo: location.centerYAnchor).isActive = true
        heart.leftAnchor.constraint(equalTo: location.rightAnchor, constant: 2).isActive = true
        
        location.bottomAnchor.constraint(equalTo: accept.topAnchor, constant: -20).isActive = true
        location.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor, constant: -10).isActive = true
        
        accept.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -50).isActive = true
        accept.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        accept.widthAnchor.constraint(equalToConstant: 120).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    override func keyDown(with: NSEvent) {
        switch with.keyCode {
        case 36:
            close()
        default:
            super.keyDown(with: with)
        }
    }
    
    override func cancelOperation(_: Any?) {
        close()
    }
}
