import Foundation

protocol DownloadQueueProtocol {
    // TODO: Make it reusable!!!
    static var shared: DownloadQueueProtocol { get }
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

    var count: Int {
        get {
            return self._store.count
        }
    }
    var isEmpty: Bool {
        return self.pending.isEmpty
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
    private var pending: [Download] {
        get {
            return _store.filter{ [.Pending, .Downloading].contains($0.state) }
        }
    }
    
    private init() {
        print("DownloadQueue started")
    }
    
    func enqueue(someDownloads: [Download]) {
        print("before filter: \(someDownloads.count)")
        let existing = self._store.map{ $0.url.absoluteString }
        let valid = uniq(source: someDownloads)
        let notInStore = valid.filter{ !existing.contains($0.url.absoluteString) }
        print("after filter: \(notInStore.count)")
        self._store += notInStore
    }
    
    
    func clean() {
        self._store = []
    }
    
    func next() -> Download? {
        guard let next = self.pending[safe: 0] else {
            return nil
        }
//        print("found state: \(next.state.rawValue)")
        if next.state == .Downloading {
            return nil
        }
        return next
    }
}
