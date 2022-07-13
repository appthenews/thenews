import QuartzCore

final class TextLayer: CATextLayer {
    override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
    
    override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }
}
