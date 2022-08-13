import AppKit
import Coffee
import Combine
import News

final class Content: NSVisualEffectView {
    private weak var background: NSView!
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        let background = NSView()
        background.wantsLayer = true
        self.background = background
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        background.translatesAutoresizingMaskIntoConstraints = false
        addSubview(background)
        
        let separator = Separator()
        separator.isHidden = true
        addSubview(separator)
        
        let scroll = Scroll()
        scroll.isHidden = true
        scroll.contentView.postsBoundsChangedNotifications = true
        scroll.contentView.postsFrameChangedNotifications = false
        addSubview(scroll)
        
        let header = Text(vibrancy: true)
        header.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        scroll.documentView!.addSubview(header)
        
        let title = Text(vibrancy: true)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.isSelectable = true
        title.allowsEditingTextAttributes = true
        scroll.documentView!.addSubview(title)
        
        let description = Text(vibrancy: true)
        description.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        description.isSelectable = true
        description.allowsEditingTextAttributes = true
        scroll.documentView!.addSubview(description)
        
        let empty = Vibrant(layer: false)
        addSubview(empty)
        
        let image = NSImageView(image: .init(named: "Logo") ?? .init())
        image.contentTintColor = .quaternaryLabelColor
        image.translatesAutoresizingMaskIntoConstraints = false
        empty.addSubview(image)
        
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: scroll.documentView!.topAnchor, constant: 25).isActive = true
        header.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
        header.rightAnchor.constraint(lessThanOrEqualTo: title.rightAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: scroll.documentView!.leftAnchor, constant: 70).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: scroll.documentView!.rightAnchor, constant: -70).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant: 700).isActive = true
        title.centerXAnchor.constraint(equalTo: scroll.documentView!.centerXAnchor).isActive = true
        let titleWidth = title.widthAnchor.constraint(equalToConstant: 700)
        titleWidth.priority = .defaultLow
        titleWidth.isActive = true
        let titleLeft = title.leftAnchor.constraint(equalTo: description.leftAnchor)
        titleLeft.priority = .defaultLow
        titleLeft.isActive = true
        
        description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
        description.leftAnchor.constraint(greaterThanOrEqualTo: scroll.documentView!.leftAnchor, constant: 70).isActive = true
        description.rightAnchor.constraint(lessThanOrEqualTo: scroll.documentView!.rightAnchor, constant: -70).isActive = true
        description.widthAnchor.constraint(lessThanOrEqualToConstant: 700).isActive = true
        description.bottomAnchor.constraint(equalTo: scroll.documentView!.bottomAnchor, constant: -60).isActive = true
        description.centerXAnchor.constraint(equalTo: scroll.documentView!.centerXAnchor).isActive = true
        let descriptionWidth = description.widthAnchor.constraint(equalToConstant: 700)
        descriptionWidth.priority = .defaultLow
        descriptionWidth.isActive = true
        
        empty.topAnchor.constraint(equalTo: topAnchor).isActive = true
        empty.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        empty.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        empty.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        image.centerXAnchor.constraint(equalTo: empty.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: empty.centerYAnchor).isActive = true
        
        session
            .item
            .combineLatest(session.font, session.reader)
            .sink { item, font, reader in
                scroll.contentView.bounds.origin.y = 0
                
                if let item = item {
                    empty.isHidden = true
                    
                    let string = NSMutableAttributedString()
                    string.append(.init(string: item.feed.provider.title,
                                        attributes: [
                                            .font: NSFont.systemFont(ofSize:
                                                                        NSFont.preferredFont(forTextStyle: .body).pointSize,
                                                                     weight: .regular),
                                            .foregroundColor: reader ? .init(named: "Text")! : NSColor.secondaryLabelColor]))
                    string.append(.init(string: " – " + item
                        .date
                        .formatted(.relative(presentation: .named, unitsStyle: .wide)),
                                        attributes: [
                                            .font: NSFont.systemFont(ofSize:
                                                                        NSFont.preferredFont(forTextStyle: .body).pointSize,
                                                                     weight: .light),
                                            .foregroundColor: reader ? .init(named: "Text")! : NSColor.secondaryLabelColor]))
                    header.attributedStringValue = string
                    
                    title.attributedStringValue = .init(
                        string: item.title,
                        attributes: [.font: NSFont.systemFont(ofSize:
                                                                NSFont.preferredFont(forTextStyle: .title2).pointSize + font,
                                                              weight: .medium),
                                     .kern: 1,
                                     .foregroundColor: reader ? .init(named: "Text")! : NSColor.labelColor])
                    
                    description.attributedStringValue = .init(
                        string: item.description,
                        attributes: [.font: NSFont.systemFont(ofSize:
                                                                NSFont.preferredFont(forTextStyle: .body).pointSize + font,
                                                              weight: .regular),
                                     .kern: 1,
                                     .foregroundColor: reader ? .init(named: "Text")! : NSColor.labelColor])
                } else {
                    header.attributedStringValue = .init()
                    title.attributedStringValue = .init()
                    description.attributedStringValue = .init()
                    empty.isHidden = false
                }
            }
            .store(in: &subs)
        
        session
            .loading
            .filter {
                !$0
            }
            .sink { _ in
                scroll.isHidden = false
            }
            .store(in: &subs)
        
        session
            .reader
            .sink { [weak self] in
                if $0 {
                    self?.state = .inactive
                    self?.material = .underPageBackground
                    background.isHidden = false
                } else {
                    self?.state = .active
                    self?.material = .sidebar
                    background.isHidden = true
                }
            }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == scroll.contentView
            }
            .map {
                $0.bounds.minY < 25
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
            .store(in: &subs)
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        NSApp
            .effectiveAppearance
            .performAsCurrentDrawingAppearance {
                background.layer!.backgroundColor = NSColor(named: "Background")!.cgColor
            }
    }
}
