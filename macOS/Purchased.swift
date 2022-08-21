import AppKit
import Coffee
import Combine

final class Purchased: Notify {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(size: .init(width: 300, height: 300))
        
        let image = NSImageView(image: .init(systemSymbolName: "arrow.up.heart.fill", accessibilityDescription: nil) ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.symbolConfiguration = .init(pointSize: 60, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .controlAccentColor))
        contentView!.addSubview(image)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let string = NSMutableAttributedString()
        string.append(.init(string: "Sponsor\n",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize,
                                                         weight: .medium),
                                .foregroundColor: NSColor.labelColor,
                                .paragraphStyle: paragraph]))
        string.append(.init(string: "We received your\ncontribution.",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize,
                                                         weight: .light),
                                .foregroundColor: NSColor.secondaryLabelColor,
                                .paragraphStyle: paragraph]))
        
        let text = Text(vibrancy: true)
        text.attributedStringValue = string
        contentView!.addSubview(text)
        
        let accept = Control.Prominent(title: "OK")
        accept
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        contentView!.addSubview(accept)
        
        image.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 60).isActive = true
        
        text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        text.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        accept.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -50).isActive = true
        accept.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        accept.widthAnchor.constraint(equalToConstant: 120).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
}
