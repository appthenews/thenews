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
                guard session.store.status.value == .ready else { return }
                
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
        
        let disclaimer = Text(vibrancy: true)
        disclaimer.font = .preferredFont(forTextStyle: .footnote)
        disclaimer.stringValue = "1 time purchase"
        disclaimer.textColor = .secondaryLabelColor
        addSubview(disclaimer)
        
        Task {
            product = await session.store.load(item: .sponsor)
            
            if let product = product {
                disclaimer.stringValue = "1 time purchase of " + product.displayPrice
            }
        }
        
        widthAnchor.constraint(equalToConstant: 300).isActive = true
        bottomAnchor.constraint(equalTo: disclaimer.bottomAnchor).isActive = true
        
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        control.widthAnchor.constraint(equalToConstant: 160).isActive = true
        control.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        control.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        disclaimer.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 10).isActive = true
        disclaimer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        session
            .store
            .status
            .receive(on: DispatchQueue.main)
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
