import Foundation

extension Dictionary {
    public static func += <Key, Value>(left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }

    public static func + <Key, Value>(left: inout [Key: Value], right: [Key: Value]) -> [Key: Value] {
        for (key, value) in right {
            left[key] = value
        }
        return left
    }
}
