import Foundation

// MARK: Implementation
class DataRequestAPI: SubSonicDataProtocol {
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

    let client: HTTPRequestCLientProtocol
    weak var delegate: SubSonicDataDelegate?
    
    init(client: HTTPRequestCLientProtocol, builder: URLBuilderProtocol) {
        self.client = client
        self._urlBuilder = builder
    }
    
    init(client: HTTPRequestCLientProtocol) {
        self.client = client
    }
}

