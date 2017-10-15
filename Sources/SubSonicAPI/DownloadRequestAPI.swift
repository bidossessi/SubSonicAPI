import Foundation

// MARK: Implementation
class DownloadRequestAPI: SubSonicDownloadProtocol {
    let client: MediaDownloadClientProtocol
    weak var delegate: SubSonicDownloadDelegate?
    let downloadQueue: DownloadQueueProtocol = DownloadQueue.shared

    init(client: MediaDownloadClientProtocol) {
        self.client = client
    }
}

