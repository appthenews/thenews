import AppKit
import Coffee

final class Filters: NSView {
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        super.init(frame: .init(origin: .zero, size: .init(width: 280, height: 120)))
        
        let title = Text(vibrancy: true)
        title.stringValue = "Showing"
        title.font = .preferredFont(forTextStyle: .title3)
        title.textColor = .secondaryLabelColor
        addSubview(title)
        
        let segmented = NSSegmentedControl(labels: ["All", "Not read", "Bookmarks"],
                                         trackingMode: .selectOne,
                                         target: self,
                                         action: #selector(change))
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.controlSize = .large
        segmented.selectedSegment = session.showing.value
        addSubview(segmented)
        
        title.bottomAnchor.constraint(equalTo: segmented.topAnchor, constant: -10).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        segmented.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 15).isActive = true
        segmented.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    @objc private func change(_ segmented: NSSegmentedControl) {
        guard session.showing.value != segmented.selectedSegment else { return }
        session.showing.value = segmented.selectedSegment
        UserDefaults.standard.set(segmented.selectedSegment, forKey: "showing")
    }
}
