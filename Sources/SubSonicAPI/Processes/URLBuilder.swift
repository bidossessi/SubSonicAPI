import Cocoa

protocol URLBuilder: class {
    static var shared: URLBuilder { get }
    func url(config: SubSonicConfig, endpoint: String, params: [String: String]) -> URL
}



class URLMaker: URLBuilder {

    // My job is to return properly formatted SubSonic URLs
    static let shared: URLBuilder = URLMaker()
    
    private init() {
        print("URLMonitor started")
    }

    private func makeBaseUrl(config: SubSonicConfig, endpoint: String) -> String {
        let serverUrl = config.serverUrl
        return "\(serverUrl)/rest/\(endpoint).view"
    }
    
    func url(config: SubSonicConfig, endpoint: String, params: [String: String]) -> URL {
        let baseUrl: String = self.makeBaseUrl(config: config, endpoint: endpoint)
        
        let defaultParams: [String: String] = [
            "u": config.username,
            "p": config.password,
            "c": Constants.SubSonicInfo.apiName,
            "v": Constants.SubSonicInfo.apiVersion,
            // Ideally, this should come from config (advanced)
            "f": Constants.SubSonicInfo.apiFormat
        ]
        var queryParams: [String: String] = [:]
        for (key, value) in defaultParams {
            queryParams[key] = value
        }
        for (key, value) in params {
            queryParams[key] = value
        }
        
        let parameterString = queryParams.stringFromHttpParameters()
        let finalString = "\(baseUrl)?\(parameterString)"
        return URL(string: finalString)!
    }
}
