import AppKit
import Combine
import News

final class List: NSScrollView {
    private var appear = Appearance()
    private var subs = Set<AnyCancellable>()
    private let clear = PassthroughSubject<Void, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()
    private let select = PassthroughSubject<CGPoint, Never>()
    private let refresh = PassthroughSubject<Void, Never>()

    required init?(coder: NSCoder) { nil }
    init(session: Session) {
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
        
        let clip = CurrentValueSubject<_, Never>(CGRect.zero)
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
                .dropFirst()
                .removeDuplicates()) { info, clip in
                    info
                        .filter {
                            clip.intersects($0.rect)
                        }
                }
                .removeDuplicates()
                .combineLatest(session.reader)
                .sink { visible, reader in
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
                            cell.state = session.item.value?.link == info.item.link ? .selected : .none
                            cell.reader = reader
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
                        $0.state != .selected
                    }
                    .forEach {
                        $0.state = $0.info?.item.link == highlighted?.link ? .highlighted : .none
                    }
            }
            .store(in: &subs)
        
        highlight
            .map { point in
                cells
                    .compactMap(\.info)
                    .filter {
                        session.item.value?.link != $0.item.link
                    }
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
        
        session
            .items
            .combineLatest(session.font,
                           session.reader,
                           refresh)
            .sink { [weak self] items, font, reader, _ in
                guard
                    !items.isEmpty,
                    var appearance = self?.appear
                else {
                    info.send([])
                    size.send(.zero)
                    highlighted.value = nil
                    self?.contentView.bounds.origin.y = 0
                    return
                }
                
                appearance.reader = reader
                appearance.title = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize + font, weight: .regular)
                
                let result = items
                    .reduce(into: (info: Set<Info>(), y: CGFloat())) {
                        let info = Info(item: $1, y: $0.y, appearance: appearance)
                        $0.info.insert(info)
                        $0.y = info.rect.maxY + 1
                    }
                
                info.send(result.info)
                size.send(.init(width: 0, height: result.y + 1))
                highlighted.value = nil
                
                if let current = session.item.value?.link,
                   let rect = result.info.first(where: { $0.item.link == current })?.rect {
                    
                    if !clip.value.intersects(rect) {
                        self?.show(rect: rect, animated: false)
                    }
                } else {
                    self?.contentView.bounds.origin.y = 0
                }
            }
            .store(in: &subs)
        
        select
            .compactMap { point in
                cells
                    .compactMap(\.info)
                    .first {
                        $0.rect.contains(point)
                    }?
                    .item
            }
            .subscribe(session.item)
            .store(in: &subs)
        
        session
            .item
            .combineLatest(info)
            .removeDuplicates {
                $0.0 == $1.0
            }
            .sink { [weak self] selected, info in
                if let link = selected?.link {
                    if cells.contains(where: { $0.info?.item.link == link }) {
                        cells
                            .forEach {
                                $0.state = $0.info?.item.link == link ? .selected : .none
                            }
                    } else if let rect = info.first(where: { $0.item.link == link })?.rect {
                        self?.show(rect: rect, animated: true)
                    }
                } else {
                    cells
                        .forEach {
                            $0.state = .none
                        }
                }
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
    
    override func mouseUp(with: NSEvent) {
        switch with.clickCount {
        case 1:
            select.send(point(with: with))
        default:
            break
        }
    }
    
    override func updateLayer() {
        super.updateLayer()
        
        if NSApp.effectiveAppearance.name == NSAppearance.Name.darkAqua {
            appear.primary = .init(white: 1, alpha: 1)
            appear.secondary = .init(white: 1, alpha: 0.5)
            appear.tertiary = .init(white: 1, alpha: 0.4)
            appear.text = .init(white: 0.82, alpha: 1)
        } else {
            appear.primary = .init(white: 0, alpha: 1)
            appear.secondary = .init(white: 0, alpha: 0.5)
            appear.tertiary = .init(white: 0, alpha: 0.4)
            appear.text = .init(white: 0.32, alpha: 1)
        }
        
        refresh.send()
    }
    
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
    
    private func show(rect: CGRect, animated: Bool) {
        if rect.midY >= contentView.bounds.midY {
            contentView.bounds.origin.y = rect.maxY - contentView.bounds.height
        } else {
            contentView.bounds.origin.y = rect.minY
        }
        
        if animated && contentView.layer!.animation(forKey: "bounds") == nil {
            contentView.layer!.add({
                $0.duration = 0.2
                $0.timingFunction = .init(name: .easeInEaseOut)
                $0.isRemovedOnCompletion = true
                return $0
            } (CABasicAnimation(keyPath: "bounds")), forKey: "bounds")
        }
    }
}
