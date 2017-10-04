import Foundation

protocol HTTPClient: class, URLSessionDelegate {
    var taskDataMap: [URLSessionTask: Data] { get set }
    weak var delegate: QueryDelegate? { get set }
    func query(_ url: URL)
}


protocol QueryDelegate: class {
    func api(_: HTTPMaestro, requestData data: Data)
}


class NetClient: NSObject, HTTPClient {
    weak var delegate: QueryDelegate?
    var taskDataMap: [URLSessionTask : Data] = [:]
    
    override private init() {
        super.init()
        print("DataMonitor started")
    }

    
    var session : URLSession {
        get {
            let config = URLSessionConfiguration.default
            // Get this from settings
            config.allowsCellularAccess = true
            // TODO: Below policy will need revising
            config.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        }
    }

    func query(_ url: URL) {
        let task = self.session.dataTask(with: url)
        task.resume()
    }
    

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if error != nil {
            fatalError("HTTP error: \(error!)")
        }
        else{
            print("HTTPMaestro Request - complete!")
            let data = self.taskDataMap.removeValue(forKey: task)!
            self.delegate?.api(self, requestData: data)
        }
    }
}

extension HTTPClient: URLSessionDataDelegate {
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        guard let sourceURL = dataTask.originalRequest?.url else { return }
        print("first response received: \(sourceURL)")
        self.taskDataMap.updateValue(Data(), forKey: dataTask)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        var existing: Data = taskDataMap[dataTask] ?? Data()
        existing.append(data)
        self.taskDataMap.updateValue(existing, forKey: dataTask)
    }
}

