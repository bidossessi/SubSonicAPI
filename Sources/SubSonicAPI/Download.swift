import Foundation


enum DownloadState: String {
    case Downloading = "Downloading"
    case Cancelled = "Cancelled"
    case Completed = "Completed"
    case Paused = "Paused"
    case Pending = "Pending"
}

protocol Downloadable: Hashable {
    var item: Song { get }
    var task: URLSessionDownloadTaskProtocol { get }
    var state: DownloadState { get set }
    var resumeData: Data? { get set }
    var progress: Double { get }
    var url: URL { get }
    var tmpFile: URL? {get set}
    
}


class Download: Downloadable {
    
    let item: Song
    let url: URL
    var task: URLSessionDownloadTaskProtocol
    var state: DownloadState = .Pending
    var resumeData: Data?
    var progress: Double = 0
    var tmpFile: URL?
    
    init(item: Song, url: URL, task: URLSessionDownloadTaskProtocol) {
        self.item = item
        self.url = url
        self.task = task
    }
    

    // MARK: - Hashable
    var hashValue: Int {
        return url.absoluteString.hashValue
    }
    static func ==(lhs: Download, rhs: Download) -> Bool {
        return lhs.url.absoluteString == rhs.url.absoluteString 
    }
}


