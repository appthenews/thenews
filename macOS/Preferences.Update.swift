import AppKit
import Coffee
import News

extension Preferences {
    final class Update: NSVisualEffectView {
        private let session: Session
        
        required init?(coder: NSCoder) { nil }
        init(session: Session) {
            self.session = session
            super.init(frame: .init(origin: .zero, size: .init(width: 400, height: 300)))
            let updateTitle = Text(vibrancy: false)
            updateTitle.stringValue = "Refresh every"
            
            let update = NSSegmentedControl(labels: [Interval.hour,
                                                     .hours3,
                                                     .hours6,
                                                     .day].map(\.title),
                                            trackingMode: .selectOne,
                                            target: self,
                                            action: #selector(update))
            update.controlSize = .large
            
            let deleteTitle = Text(vibrancy: false)
            deleteTitle.stringValue = "Delete after"
            
            let delete = NSSegmentedControl(labels: [Interval.hours6,
                                                     .day,
                                                     .days3,
                                                     .week].map(\.title),
                                            trackingMode: .selectOne,
                                            target: self,
                                            action: #selector(delete))
            delete.controlSize = .large
            
            [updateTitle,
             deleteTitle]
                .forEach {
                    $0.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .medium)
                    $0.textColor = .controlAccentColor
                }
            
            let stack = Stack(views: [
                updateTitle,
                update,
                deleteTitle,
                delete])
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.orientation = .vertical
            stack.alignment = .leading
            stack.setCustomSpacing(30, after: update)
            addSubview(stack)
            
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            Task {
                let preferences = await session.cloud.model.preferences
                
                switch preferences.fetch {
                case .hour:
                    update.selectedSegment = 0
                case .hours3:
                    update.selectedSegment = 1
                case .hours6:
                    update.selectedSegment = 2
                default:
                    update.selectedSegment = 3
                }
                
                switch preferences.clean {
                case .hours6:
                    delete.selectedSegment = 0
                case .day:
                    delete.selectedSegment = 1
                case .days3:
                    delete.selectedSegment = 2
                default:
                    delete.selectedSegment = 3
                }
            }
        }
        
        @objc private func update(_ segmented: NSSegmentedControl) {
            Task {
                switch segmented.selectedSegment {
                case 0:
                    await session.cloud.fetch(interval: .hour)
                case 1:
                    await session.cloud.fetch(interval: .hours3)
                case 2:
                    await session.cloud.fetch(interval: .hours6)
                default:
                    await session.cloud.fetch(interval: .day)
                }
            }
        }
        
        @objc private func delete(_ segmented: NSSegmentedControl) {
            Task {
                switch segmented.selectedSegment {
                case 0:
                    await session.cloud.clean(interval: .hours6)
                case 1:
                    await session.cloud.clean(interval: .day)
                case 2:
                    await session.cloud.clean(interval: .days3)
                default:
                    await session.cloud.clean(interval: .week)
                }
            }
        }
    }
}
