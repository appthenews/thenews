import AppKit
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
        
        let flip = Flip()
        flip.translatesAutoresizingMaskIntoConstraints = false
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.documentView = flip
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        scroll.automaticallyAdjustsContentInsets = false
        scroll.isHidden = true
        addSubview(scroll)
        
        let header = Text(vibrancy: true)
        header.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        flip.addSubview(header)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        
        let title = Text(vibrancy: true)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.isSelectable = true
        title.allowsEditingTextAttributes = true
        title.alignment = .justified
        flip.addSubview(title)
        
        let description = Text(vibrancy: true)
        description.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        description.isSelectable = true
        description.allowsEditingTextAttributes = true
        description.alignment = .justified
        flip.addSubview(description)
        
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
        
        scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        flip.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        flip.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        flip.rightAnchor.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: flip.topAnchor, constant: 25).isActive = true
        header.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 70).isActive = true
        header.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -70).isActive = true
        
        title.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5).isActive = true
        title.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 70).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -70).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant: 850).isActive = true
        
        description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
        description.leftAnchor.constraint(equalTo: flip.leftAnchor, constant: 70).isActive = true
        description.rightAnchor.constraint(lessThanOrEqualTo: flip.rightAnchor, constant: -70).isActive = true
        description.widthAnchor.constraint(lessThanOrEqualToConstant: 850).isActive = true
        description.bottomAnchor.constraint(equalTo: flip.bottomAnchor, constant: -60).isActive = true
        
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
                                     .foregroundColor: reader ? .init(named: "Text")! : NSColor.labelColor,
                                     .paragraphStyle: paragraph])
                    
                    description.attributedStringValue = .init(
                        string: item.description,
                        attributes: [.font: NSFont.systemFont(ofSize:
                                                                NSFont.preferredFont(forTextStyle: .body).pointSize + font,
                                                              weight: .regular),
                                     .kern: 1,
                                     .foregroundColor: reader ? .init(named: "Text")! : NSColor.labelColor,
                                     .paragraphStyle: paragraph])
                    
                    Task {
                        await session.cloud.read(item: item)
                    }
                    
                    session.review()
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
