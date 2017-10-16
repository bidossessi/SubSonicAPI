import Foundation

// MARK: Implementation
class DownloadRequestAPI: SubSonicDownloadProtocol {
    private var _urlBuilder: URLBuilderProtocol?
    var urlBuilder: URLBuilderProtocol {
        get {
            if _urlBuilder == nil {
                _urlBuilder = URLBuilder()
            }
            return _urlBuilder!
        }
        set(builder){
            _urlBuilder = builder
        }
    }
    
    let client: MediaDownloadClientProtocol
    weak var delegate: SubSonicDownloadDelegate?
    let downloadQueue: DownloadQueueProtocol = DownloadQueue.shared

    init(client: MediaDownloadClientProtocol, builder: URLBuilderProtocol) {
        self.client = client
        self._urlBuilder = builder
    }
    
    init(client: MediaDownloadClientProtocol) {
        self.client = client
    }
}

