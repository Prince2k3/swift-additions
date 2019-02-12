import Foundation

extension String {
    public func snakeCase() -> String {
        let us = sub(pattern: "(.)([A-Z][a-z]+)", "\\1_\\2", self)
        return sub(pattern: "([a-z0-9])([A-Z])", "\\1_\\2", us).lowercased()
    }

    public func camelCase(_ lowercaseFirstLetter: Bool = true) -> String {
        let items = components(separatedBy: "_")
        var camelCase = ""
        items.enumerated().forEach {
            camelCase += 0 == $0 && lowercaseFirstLetter ? $1 : $1.capitalized
        }
        return camelCase
    }
}

private func sub(pattern: String, _ repl: String, _ string: String) -> String {
    var repl = repl
    
    for idx in 0...9 {
        repl = repl.replace("\\\(idx)", with: "$\(idx)")
    }
    
    guard
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        else { return string }
    return regex.stringByReplacingMatches(in: string, options: [], range: NSRange(location: 0, length: string.count), withTemplate: repl)
}
