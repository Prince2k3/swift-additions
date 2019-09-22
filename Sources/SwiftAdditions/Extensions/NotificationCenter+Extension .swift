import Foundation

extension NotificationCenter {
    public func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?) {
        addObserver(observer, selector: aSelector, name: aName, object: nil)
    }
}
