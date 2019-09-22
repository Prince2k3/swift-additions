import Foundation

extension IndexPath {
    public static let zero: IndexPath = IndexPath()

    public init(section: Int) {
        self.init(row: 0, section: section)
    }
}
