import Foundation

public struct Paged<T: Codable> {
    public private(set) var items: [T] = []
    public private(set) var total: Int
    public private(set) var currentPage: Int
    
    public let numberOfPages: Int
    public let perPage: Int
    
    public var shouldContinuePaging: Bool {
        return self.currentPage < self.numberOfPages
    }
    
    public var count: Int {
        return self.items.count
    }
    
    public func indexes(for page: Int) -> CountableRange<Int>? {
        guard
            page >= self.numberOfPages
            else { return nil }
        
        if page == 1 {
            return 0..<self.perPage
        }
        
        let position = page * self.perPage
        return position..<Swift.min((position + self.perPage), self.total)
    }
    
    public init(perPage: Int, total: Int) {
        self.perPage = perPage
        self.total = total
        self.currentPage = 0
        self.numberOfPages = Int(floor(Double(self.total / self.perPage))) + 1
    }
    
    public mutating func set(contentsOf newItems: [T], forPage page: Int) {
        guard
            newItems.count <= self.perPage
            else { fatalError("the items in the array are bigger than the pageSize.") }
        
        guard
            self.currentPage <= page
            else { fatalError("New Page must be greater than current page") }
        
        if page == 1 {
            self.items = newItems
        } else if page > self.currentPage {
            self.items.append(contentsOf: newItems)
        } else {
            guard
                let indexes = self.indexes(for: page)
                else { fatalError("Indexes are out of range") }
            self.items.replaceSubrange(indexes, with: newItems)
        }
        
        self.currentPage = page
    }
    
    public mutating func removeAll(keepingCapacity: Bool = true) {
        self.items.removeAll(keepingCapacity: keepingCapacity)
    }
}

extension Paged: BidirectionalCollection {
    public typealias Index = Int
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
       return self.count
    }
    
    public func makeIterator() -> IndexingIterator<Paged> {
        return IndexingIterator(_elements: self)
    }
    
    public func index(after currentIndex: Int) -> Int {
        return currentIndex + 1
    }
    
    public func index(before currentIndex: Int) -> Int {
        return currentIndex - 1
    }
    
    public subscript(position: Int) -> T {
        get { return self.items[position] }
        set { self.items[position] = newValue }
    }
}
