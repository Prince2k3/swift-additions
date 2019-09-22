import Foundation
import UIKit

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        return self?.trim().isEmpty ?? true
    }
}

extension String {
    public func explode(_ separator: Character) -> [String] {
        return self.split(separator: separator).map { String($0) }
    }

    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func replace(_ target: String, with string: String) -> String {
        return self.replacingOccurrences(of: target, with: string, options: [.literal], range: nil)
    }

    public func isMatch(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", string)
        return predicate.evaluate(with: self)
    }

    public func matches(_ string: String, options: NSRegularExpression.Options = .caseInsensitive) -> [NSTextCheckingResult]? {

        let length = self.count
        let regex: NSRegularExpression

        do {
            regex = try NSRegularExpression(pattern: string, options: options)
        } catch {
            return nil
        }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: length))
        return matches
    }

    public func substring(_ location: Int, length: Int) -> String {
        let start = index(startIndex, offsetBy: location)
        let end = index(startIndex, offsetBy: (location + length))
        let range = start..<end
        return String(self[range])
    }
}
