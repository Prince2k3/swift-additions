import Foundation
import CoreGraphics

extension CGRect {
    public init(size: CGSize) {
        self.init(origin: CGPoint(), size: size)
    }

    public init(width: CGFloat, height: CGFloat) {
        self.init(width: Double(width), height: Double(height))
    }

    public init(width: Double, height: Double) {
        self.init(size: CGSize(width: width, height: height))
    }
}
