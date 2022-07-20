import AppKit
import Combine
import StoreKit

final class Froob: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
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
    }
}
