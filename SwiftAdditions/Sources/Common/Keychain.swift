import Foundation

public class Keychain {
    private var query: [String: Any] {
        var query = self.service
        query[.returnData] = kCFBooleanTrue
        return query
    }
    
    private var service: [String: Any] {
        var query = [String: Any]()
        query[.klass] = kSecClassGenericPassword
        return query
    }
    
    let keyPrefix: String?
    
    var lastStatus: Status = .success
    
    init(keyPrefix: String? = Bundle.main.bundleIdentifier) {
        self.keyPrefix = keyPrefix
    }
    
    @discardableResult
    public func reset() -> Bool {
        let query = self.query
        let status = Status(SecItemDelete(query as CFDictionary))
        return status == .success
    }
    
    public func value<T: Codable>(forKey key: String) -> T? {
        let hierKey = hierarchicalKey(key)
        var query = self.query
        query[.service] = hierKey
        
        var value: AnyObject?
        self.lastStatus = Status(SecItemCopyMatching(query as CFDictionary, &value))

        guard let data = value as? Data else { return nil }
        let decoder = JSONDecoder()
        do { return try decoder.decode(T.self, from: data) }
        catch { return nil }
    }
    
    @discardableResult
    public func remove(key: String, accessibility: Keychain.Accessibility = .default) -> Bool {
        var query = self.query
        query[.service] = hierarchicalKey(key)
        self.lastStatus = Status(SecItemDelete(query as CFDictionary))
        
        return self.lastStatus == .success || self.lastStatus == .itemNotFound
    }
    
    public func set<T: Codable>(_ value: T?, key: String, accessibility: Keychain.Accessibility = .default) -> Bool {
        guard
            let value = value
            else { remove(key: key) ; return true }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(value)
            let hierKey = hierarchicalKey(key)
            
            var query = self.service
            query[.service] = hierKey
            query[.accessible] = accessibility.value
            query[.valueData] = data
            
            self.lastStatus = Status(SecItemAdd(query as CFDictionary, nil))
            if self.lastStatus == .duplicateItem {
                var query = self.query
                query[.service] = hierKey
                self.lastStatus = Status(SecItemDelete(query as CFDictionary))
                if self.lastStatus == .success {
                    self.lastStatus = Status(SecItemAdd(query as CFDictionary, nil))
                }
            }
            
            return self.lastStatus == .success
        }
        catch { return false }
    }
    
    private func hierarchicalKey(_ key: String) -> String {
        return self.keyPrefix.flatMap { "\($0).\(key)" } ?? "\(key)"
    }
}

extension Keychain {
    public static func value<T: Codable>(forKey key: String) -> T? {
        return Keychain().value(forKey: key)
    }
    
    @discardableResult
    public static func remove(key: String, accessibility: Keychain.Accessibility = .default) -> Bool {
        return Keychain().remove(key: key, accessibility: accessibility)
    }
    
    @discardableResult
    public static func set<T: Codable>(_ value: T?, key: String, accessibility: Keychain.Accessibility = .default) -> Bool {
        return Keychain().set(value, key: key, accessibility: accessibility)
    }
    
    @discardableResult
    public static func reset() -> Bool {
        return Keychain().reset()
    }
}

///

extension Keychain {
    public enum Status: Error {
        case success
        case unimplemented
        case param
        case allocate
        case notAvailable
        case authFailed
        case duplicateItem
        case itemNotFound
        case interactionNotAllowed
        case decode
        case unknown
        
        public init(_ value: OSStatus) {
            switch value {
            case errSecSuccess:
                self = .success
            case errSecUnimplemented:
                self = .unimplemented
            case errSecParam:
                self = .param
            case errSecAllocate:
                self = .allocate
            case errSecNotAvailable:
                self = .notAvailable
            case errSecAuthFailed:
                self = .authFailed
            case errSecDuplicateItem:
                self = .duplicateItem
            case errSecItemNotFound:
                self = .itemNotFound
            case errSecInteractionNotAllowed:
                self = .interactionNotAllowed
            case errSecDecode:
                self = .decode
            default:
                self = .unknown
            }
        }
    }
    
    public enum Accessibility {
        case whenUnlocked
        case whenUnlockedThisDeviceOnly
        case afterFirstUnlock
        case afterFirstUnlockThisDeviceOnly
        case always
        case whenPasscodeSetThisDeviceOnly
        case alwaysThisDeviceOnly
        
        public static let `default`: Keychain.Accessibility = .whenUnlocked
        
        public var value: String {
            switch self {
            case .whenUnlocked:
                return String(kSecAttrAccessibleWhenUnlocked)
            case .whenUnlockedThisDeviceOnly:
                return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
            case .afterFirstUnlock:
                return String(kSecAttrAccessibleAfterFirstUnlock)
            case .afterFirstUnlockThisDeviceOnly:
                return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
            case .always:
                return String(kSecAttrAccessibleAlways)
            case .whenPasscodeSetThisDeviceOnly:
                return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            case .alwaysThisDeviceOnly:
                return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
            }
        }
    }
}

fileprivate extension String {
    static let klass = String(kSecClass)
    static let returnData = String(kSecReturnData)
    static let valueData = String(kSecValueData)
    static let itemClass = String(kSecClass)
    static let service = String(kSecAttrService)
    static let returnAttributes = String(kSecReturnAttributes)
    static let accessible = String(kSecAttrAccessible)
}
