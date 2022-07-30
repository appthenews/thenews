import AppKit
import News

extension List {
    struct Info: Hashable {
        let item: Item
        let string: NSAttributedString
        let recent: Bool
        let rect: CGRect
        
        init(item: Item, y: CGFloat, appearance: Appearance) {
            let string = NSMutableAttributedString()
            string.append(.init(string: item.feed.provider.title,
                                attributes: [
                                    .font: appearance.provider,
                                    .foregroundColor: appearance.heading(new: item.status == .new),
                                    .paragraphStyle: appearance.paragraph]))
            string.append(.init(string: " - ",
                                attributes: [
                                    .font: appearance.date,
                                    .foregroundColor: appearance.heading(new: item.status == .new),
                                    .paragraphStyle: appearance.paragraph]))
            string.append(.init(string: item.date.formatted(
                .relative(presentation: .named,
                          unitsStyle: .wide)),
                                attributes: [
                                    .font: appearance.date,
                                    .foregroundColor: appearance.heading(new: item.status == .new),
                                    .paragraphStyle: appearance.paragraph]))
            string.append(appearance.spacing)
            string.append(.init(string: item.title,
                                attributes: [
                                    .font: appearance.title,
                                    .foregroundColor: appearance.content(new: item.status == .new),
                                    .paragraphStyle: appearance.paragraph,
                                    .kern: 0.5]))
            
            let height = string.boundingRect(
                with: .init(width: 225,
                            height: CGFloat.greatestFiniteMagnitude),
                options: [
                    .usesFontLeading,
                    .usesLineFragmentOrigin,
                    .truncatesLastVisibleLine,
                    .usesDeviceMetrics])
                .height
            
            rect = .init(x: 0, y: y, width: 290, height: ceil(height) + 20)
            recent = item.recent
            self.item = item
            self.string = string
        }
    }
}
