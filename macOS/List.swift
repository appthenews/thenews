import AppKit
import Combine
import News

final class List: NSScrollView {
    private var subs = Set<AnyCancellable>()
    private let clear = PassthroughSubject<Void, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()

    required init?(coder: NSCoder) { nil }
    init(session: Session, items: AnyPublisher<[Item], Never>) {
        var cells = Set<Cell>()
        let info = PassthroughSubject<Set<Info>, Never>()
        let size = PassthroughSubject<CGSize, Never>()
        let highlighted = CurrentValueSubject<Item?, Never>(nil)
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        scrollerInsets.top = 2
        scrollerInsets.bottom = 2

        let content = Flip()
        documentView = content
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        contentView.postsBoundsChangedNotifications = true
        contentView.postsFrameChangedNotifications = true
        drawsBackground = false
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self))
        
        let clip = PassthroughSubject<CGRect, Never>()
        clip
            .combineLatest(size) {
                .init(width: max($0.width, $1.width), height: max($0.height, $1.height))
            }
            .removeDuplicates()
            .sink {
                content.frame.size = $0
            }
            .store(in: &subs)

        info
            .combineLatest(clip
                .removeDuplicates()) { info, clip in
                    info
                        .filter {
                            clip.intersects($0.rect)
                        }
                }
                .removeDuplicates()
                .sink { visible in
                    cells
                        .filter {
                            $0.info != nil && !visible.contains($0.info!)
                        }
                        .forEach {
                            $0.removeFromSuperview()
                            $0.info = nil
                        }
                    
                    visible
                        .forEach { info in
                            let cell = cells
                                .first {
                                    $0.info == info
                                }
                            ?? cells.first {
                                $0.info == nil
                            }
                            ?? {
                                cells.insert($0)
                                return $0
                            } (Cell())
                            cell.state = .none
                            cell.info = info
                            content.addSubview(cell)
                        }
                }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .merge(with: NotificationCenter
                    .default
                    .publisher(for: NSView.frameDidChangeNotification))
            .compactMap {
                $0.object as? NSClipView
            }
            .filter { [weak self] in
                $0 == self?.contentView
            }
            .map {
                $0.documentVisibleRect.bounded
            }
            .removeDuplicates()
            .subscribe(clip)
            .store(in: &subs)
        
        highlighted
            .sink { highlighted in
                cells
                    .filter {
                        $0.state != .pressed
                    }
                    .forEach {
                        $0.state = $0.info?.item == highlighted ? .highlighted : .none
                    }
            }
            .store(in: &subs)
        
        highlight
            .map { point in
                cells
                    .compactMap(\.info)
                    .first {
                        $0
                            .rect
                            .contains(point)
                    }?
                    .item
            }
            .subscribe(highlighted)
            .store(in: &subs)
        
        clear
            .sink {
                cells
                    .filter {
                        $0.state == .highlighted
                    }
                    .forEach {
                        $0.state = .none
                    }
            }
            .store(in: &subs)
        
        items
            .sink { items in
                guard !items.isEmpty else {
                    info.send([])
                    size.send(.zero)
                    return
                }
                
                let result = items
                    .reduce(into: (info: Set<Info>(), y: CGFloat(20))) {
                        let info = Info(item: $1, y: $0.y)
                        $0.info.insert(info)
                        $0.y = info.rect.maxY + 10
                    }
                
                info.send(result.info)
                size.send(.init(width: 0, height: result.y + 10))
            }
            .store(in: &subs)
    }
    
    override func mouseExited(with: NSEvent) {
        clear.send()
    }
    
    override func mouseMoved(with: NSEvent) {
        highlight.send(point(with: with))
    }
    
    override func mouseDown(with: NSEvent) {
        guard with.clickCount == 1 else { return }
        window?.makeFirstResponder(self)
    }
    
    override func rightMouseDown(with: NSEvent) {
        highlight.send(point(with: with))
        super.rightMouseDown(with: with)
    }
    
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
}
