import AppKit
import Combine

final class Sponsor: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init(session: Session) {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 400),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        animationBehavior = .alertPanel
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .hudWindow
        contentView = content
        center()
        
        let image = NSImageView(image: .init(systemSymbolName: "arrow.up.heart", accessibilityDescription: nil) ?? .init())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.symbolConfiguration = .init(pointSize: 100, weight: .ultraLight)
            .applying(.init(hierarchicalColor: .controlAccentColor))
        image.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(image)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let string = NSMutableAttributedString()
        string.append(.init(string: "Fund The News App\n",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize,
                                                         weight: .medium),
                                .foregroundColor: NSColor.labelColor,
                                .paragraphStyle: paragraph]))
        string.append(.init(string: "Contribute to maintenance and\nmaking it available for everyone.",
                            attributes: [
                                .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize,
                                                         weight: .regular),
                                .foregroundColor: NSColor.secondaryLabelColor,
                                .paragraphStyle: paragraph]))
        
        let title = Text(vibrancy: true)
        title.attributedStringValue = string
        content.addSubview(title)
        
        let accept = Control.Prominent(title: "OK")
        accept
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        content.addSubview(accept)
        
        let cancel = Control.Plain(title: "Cancel")
        cancel
            .click
            .sink { [weak self] in
                self?.close()
            }
            .store(in: &subs)
        content.addSubview(cancel)
        
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 40).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30).isActive = true
        title.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        cancel.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -40).isActive = true
        cancel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 160).isActive = true
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


/*
 var product: Product?
 
 let title = Text(vibrancy: true)
 title.stringValue = "Contribute to\nmaintenance\nand improvement."
 title.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular)
 title.textColor = .labelColor
 title.alignment = .center
 addSubview(title)
 
 let control = Control.Prominent(title: "Sponsor")
 control
     .click
     .sink {
         if let product = product {
             Task {
                 await session.store.purchase(product)
             }
         } else {
             session.store.status.value = .error("Unable to connect to the App Store, try again later.")
         }
     }
     .store(in: &subs)
 addSubview(control)
 
 let diclaimer = Text(vibrancy: true)
 diclaimer.font = .preferredFont(forTextStyle: .footnote)
 diclaimer.stringValue = "1 time purchase"
 diclaimer.textColor = .secondaryLabelColor
 addSubview(diclaimer)
 
 Task {
     product = await session.store.load(item: .sponsor)
     
     if let product = product {
         diclaimer.stringValue = "1 time purchase of " + product.displayPrice
     }
 }
 
 widthAnchor.constraint(equalToConstant: 300).isActive = true
 bottomAnchor.constraint(equalTo: diclaimer.bottomAnchor).isActive = true
 
 title.topAnchor.constraint(equalTo: topAnchor).isActive = true
 title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
 title.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
 
 control.widthAnchor.constraint(equalToConstant: 160).isActive = true
 control.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
 control.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
 
 diclaimer.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 10).isActive = true
 diclaimer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
 
 session
     .store
     .status
     .sink {
         switch $0 {
         case let .error(error):
             let alert = NSAlert()
             alert.alertStyle = .warning
             alert.icon = .init(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
             alert.messageText = "Sponsor"
             alert.informativeText = error
             
             let cont = alert.addButton(withTitle: "OK")
             cont.keyEquivalent = "\r"
             alert.runModal()
         default:
             break
         }
     }
     .store(in: &subs)
 */
