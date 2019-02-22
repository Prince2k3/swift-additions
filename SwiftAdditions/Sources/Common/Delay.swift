import Foundation

public func delay(_ seconds: TimeInterval, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

public func delay(_ seconds: TimeInterval, workItem: DispatchWorkItem) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem)
}
