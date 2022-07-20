import AppKit
import Combine

final class Froob: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
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
                NSApp.orderFrontStandardAboutPanel(nil)
            }
            .store(in: &subs)
        addSubview(control)
        
        let diclaimer = Text(vibrancy: true)
        diclaimer.font = .preferredFont(forTextStyle: .footnote)
        diclaimer.stringValue = "1 time purchase of $300.00"
        diclaimer.textColor = .secondaryLabelColor
        addSubview(diclaimer)
        
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
    }
}
