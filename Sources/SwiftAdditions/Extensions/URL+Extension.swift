import Foundation

extension URL {
    // Sometimes the server doesn't give the use secured (https) so we can make it so!
    public func makeSecure() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        return components?.url
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}
