import Foundation

public extension FileManager {
    public static func fileExists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    public static func isDirectory(_ path: String) -> Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }

    public static func createDirectory(at url: URL, with intermediateDirectories: Bool = false, attributes: [FileAttributeKey: String] = [:]) throws {
        return try FileManager.default.createDirectory(at: url, withIntermediateDirectories: intermediateDirectories, attributes: attributes)
    }

    public static func remove(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    public static func contentsOfDirectory(at path: String) throws -> [String] {
        return try FileManager.default.contentsOfDirectory(atPath: path)
    }

    public static func searchDictionaryPath(for domain: FileManager.SearchPathDirectory,
                                            domainMask: FileManager.SearchPathDomainMask = .userDomainMask, expandTilde: Bool = true) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(domain, domainMask, expandTilde).first else { return nil }
        return URL(fileURLWithPath: path)
    }

    public static func temporaryDirectory(at pathComponent: String = "") -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        guard !pathComponent.isEmpty else { return url }
        return url.appendingPathComponent(pathComponent)
    }

    public static func applicationSupportDirectory(_ pathComponent: String = "") -> URL? {
        let url = searchDictionaryPath(for: .applicationDirectory)
        guard !pathComponent.isEmpty else { return url }
        return url?.appendingPathComponent(pathComponent)
    }

    public static func applicationSupportDirectoryExists() -> Bool {
        guard let url = applicationSupportDirectory() else { return false }
        return fileExists(url.path)
    }

    public static func documentDirectory(_ pathComponent: String = "") -> URL? {
        let url = searchDictionaryPath(for: .documentDirectory)
        guard !pathComponent.isEmpty else { return url }
        return url?.appendingPathComponent(pathComponent)
    }

    public static func documentDirectoryExists() -> Bool {
        guard let url = applicationSupportDirectory() else { return false }
        return fileExists(url.path)
    }

    public static func cacheDirectory(_ pathComponent: String = "") -> URL? {
        let url = searchDictionaryPath(for: .cachesDirectory)
        guard !pathComponent.isEmpty else { return url }
        return url?.appendingPathComponent(pathComponent)
    }

    public static func cacheDirectoryExists() -> Bool {
        guard let url = cacheDirectory() else { return false }
        return fileExists(url.path)
    }

    public static func sharedContainer(appGroupName: String, at path: String = "") -> URL? {
        guard let containterURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) else { return nil }
        let url = URL(fileURLWithPath: containterURL.path).appendingPathComponent(path)
        return url
    }

    @discardableResult
    public static func rename(at url: URL, newName: String) throws -> URL {
        var location = url.deletingLastPathComponent()
        location.appendPathComponent(newName)
        try FileManager.default.moveItem(at: url, to: location)
        return location
    }
}

extension FileManager {
    public static func makeSubfolderIfNeeded(at url: URL) throws {
        do {
            let subfolderURL = url.deletingLastPathComponent()

            if !isDirectory(subfolderURL.path) {
                try FileManager.createDirectory(at: subfolderURL, with: true)
            }
        } catch {
            throw error
        }
    }
}
