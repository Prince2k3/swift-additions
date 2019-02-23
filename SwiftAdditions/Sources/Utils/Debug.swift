import Foundation

/// Debug purposes only

public func debugDealloc<Subject>(describing instance: Subject) {
    debugLog("\(String(describing: instance)) deallocated")
}

public func debugLog(_ items: Any..., separator: String = "", terminator: String = "\n") {
    #if DEBUG || ADHOC || RAC_TST
    debugPrint(items, separator: separator, terminator: terminator)
    #endif
}
