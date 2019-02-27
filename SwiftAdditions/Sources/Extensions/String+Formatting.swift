import Foundation

extension String {
    public func format(_ format: String) -> String {
        let string = self.clearFormat(format)
        var formatedString = ""
        var position = 0

        for character in format {
            if character == "X" {
                if position < string.count {
                    let index = string.index(string.startIndex, offsetBy: position)
                    formatedString.append(String(string[index]))
                    position += 1
                } else {
                    break
                }
            } else {
                if position < string.count {
                    formatedString.append(character)
                }
            }
        }

        return formatedString
    }

    public func clearFormat(_ format: String) -> String {
        var string = self
        let symbols = format.replacingOccurrences(of: "X", with: "")
        let set = CharacterSet(charactersIn: symbols)
        string = string.components(separatedBy: set).joined()
        return string
    }
}
