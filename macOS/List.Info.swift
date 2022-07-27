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
                                    .foregroundColor: item.status == .new
                                    ? appearance.secondary
                                    : appearance.tertiary,
                                    .paragraphStyle: appearance.paragraph]))
            string.append(.init(string: " - ",
                                attributes: [
                                    .font: appearance.date,
                                    .foregroundColor: item.status == .new
                                    ? appearance.secondary
                                    : appearance.tertiary,
                                    .paragraphStyle: appearance.paragraph]))
            string.append(.init(string: item.date.formatted(
                .relative(presentation: .named,
                          unitsStyle: .wide)),
                                attributes: [
                                    .font: appearance.date,
                                    .foregroundColor: item.status == .new
                                    ? appearance.secondary
                                    : appearance.tertiary,
                                    .paragraphStyle: appearance.paragraph]))
            string.append(appearance.spacing)
            string.append(.init(string: item.title,
                                attributes: [
                                    .font: appearance.title,
                                    .foregroundColor: item.status == .new
                                    ? appearance.primary
                                    : appearance.tertiary,
                                    .paragraphStyle: appearance.paragraph,
                                    .kern: 0.5]))
            let height = string.boundingRect(
                with: .init(width: 240,
                            height: CGFloat.greatestFiniteMagnitude),
                options: [
                    .usesFontLeading,
                    .usesLineFragmentOrigin,
                    .truncatesLastVisibleLine,
                    .usesDeviceMetrics])
                .height
            
            rect = .init(x: 0, y: y, width: 310, height: ceil(height) + 30)
            recent = item.recent
            self.item = item
            self.string = string
        }
    }
}
