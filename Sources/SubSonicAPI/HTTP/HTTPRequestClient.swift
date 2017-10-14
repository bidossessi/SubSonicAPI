import Foundation

enum NetworkError: Error, Equatable {
    case Query
    case Response(code: Int)
}

func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.Query, .Query):
        return true
    case (.Response(code: let lcode), .Response(code: let rcode)):
        return lcode == rcode
    default:
        return false
    }
}

protocol HTTPRequestCLientProtocol: class {
    var taskDataMap: [URLSessionTask: Data] { get set }
    var onComplete: ((_ result: Data?, _ error: NetworkError?) ->())? { get set }
    func query(_ url: URL)
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}



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


