import Foundation



class HTTPRequestClient: NSObject, HTTPRequestCLientProtocol {
    var taskDataMap: [URLSessionTask : Data] = [:]
    var onComplete: ((_ result: Data?, _ error: NetworkError?) ->())?
    
    private var _session: URLSessionProtocol?
    var session : URLSessionProtocol {
        get {
            if _session == nil {
                let config = URLSessionConfiguration.default
                // TODO: Get this from settings
                config.allowsCellularAccess = true
                config.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
                _session = URLSession(configuration: config)
            }
            return _session!
        }
        set(newSession) {
            _session = newSession
        }
    }
    
    init(session: URLSessionProtocol) {
        super.init()
        self.session = session
    }

    func query(_ url: URL) {
        print(url.absoluteString)
        let task = self.session.dataTask(with: url) { (data, response, error) -> Void in
            
            if let _ = error {
                self.onComplete?(nil, NetworkError.Query)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.onComplete?(nil, NetworkError.Query)
                return
            }
            
            switch response.statusCode {
            case 200...299:
                self.onComplete?(data, nil)
            default:
                self.onComplete?(nil, NetworkError.Response(code:response.statusCode))
            }
            
        }
        task.resume()
    }
}


