import AppKit
import Combine

final class Topbar: NSView {
    private var subs = Set<AnyCancellable>()
    private let session: Session
    
    required init?(coder: NSCoder) { nil }
    init(session: Session) {
        self.session = session
        super.init(frame: .zero)
        
        let split3 = NSImage(systemSymbolName: "rectangle.split.3x1", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: .controlAccentColor))) ?? .init()
        
        let split2 = NSImage(systemSymbolName: "rectangle.split.2x1", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: .controlAccentColor))) ?? .init()
        
        let split1 = NSImage(systemSymbolName: "square", accessibilityDescription: nil)?
            .withSymbolConfiguration(.init(pointSize: 14, weight: .regular)
                .applying(.init(hierarchicalColor: .controlAccentColor))) ?? .init()
         
        let segmented = NSSegmentedControl(images: [split3, split2, split1],
                                         trackingMode: .selectOne,
                                         target: self,
                                         action: #selector(change))
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.selectedSegment = session.columns.value
        addSubview(segmented)
        
        let delete = Button(symbol: "trash")
        
        let share = Button(symbol: "square.and.arrow.up")
        
        let bookmark = Button(symbol: "bookmark")
        
        let open = Button(symbol: "paperplane")
        
        let stack = NSStackView(views: [delete, share, bookmark, open])
        stack.spacing = 18
        stack.setClippingResistancePriority(.defaultLow, for: .horizontal)
        addSubview(stack)
        
        segmented.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 7).isActive = true
        
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        let leading = stack.leftAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leftAnchor)
        leading.isActive = true
        
        [segmented, stack]
            .forEach {
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        session
            .columns
            .sink {
                leading.constant = $0 == 0 ? 600 : 0
            }
            .store(in: &subs)
    }
    
    @objc private func change(_ segmented: NSSegmentedControl) {
        guard session.columns.value != segmented.selectedSegment else { return }
        session.columns.value = segmented.selectedSegment
        UserDefaults.standard.set(segmented.selectedSegment, forKey: "columns")
    }
}
