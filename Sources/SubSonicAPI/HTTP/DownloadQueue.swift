import Foundation

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

protocol DownloadQueueProtocol {
    // TODO: Make it reusable!!!
    static var shared: DownloadQueueProtocol { get }
    var store: NSMutableArray { get }
    var count: Int { get }
    var remains: Int { get }
    var isEmpty: Bool { get }
    subscript(_ index: Int) -> Download? { get }
    func enqueue(someDownloads: [Download])
    func next() -> Download?
    func clean()
}

class DownloadQueue: DownloadQueueProtocol {
    static let shared: DownloadQueueProtocol = DownloadQueue()
    private var _store: [Download] = []

    // MARK: - Public facing Store
    var store: NSMutableArray {
        get {
            return NSMutableArray(array: self._store)
        }
    }
    var count: Int {
        get {
            return self._store.count
        }
    }
    var isEmpty: Bool {
        return self._store.isEmpty
    }
    
    subscript(_ index: Int) -> Download? {
        return self._store[safe: index]
    }

    // MARK: - Queue Management
    var remains: Int {
        get {
            return self.pending.count
        }
    }
    private var computeCount: Int = 1
    private var pending: [Download] {
        get {
            print("recomputed pending: \(computeCount)")
            computeCount += 1
            return _store.filter{ [.Pending, .Downloading].contains($0.state) }
        }
    }
    
    private init() {
        print("DownloadQueue started")
    }
    
    private func shouldAdd(_ d: Download) -> Bool {
        return !_store.contains(d)
    }
    
    func enqueue(someDownloads: [Download]) {
        let valid = someDownloads.filter{ shouldAdd($0) }
        self._store += valid
    }
    
    
    func clean() {
        self._store = []
        self.computeCount = 0
    }
    
    func next() -> Download? {
        guard let next = self.pending[safe: 0] else {
            return nil
        }
        if next.state == .Downloading {
            return nil
        }
        return next
    }
}
