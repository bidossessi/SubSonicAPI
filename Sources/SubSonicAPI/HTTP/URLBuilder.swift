import Foundation

protocol URLBuilder {
    func url(config: SubSonicConfig, endpoint: String, params: [String: String]) -> URL
}


extension URLBuilder {

    func url(config: SubSonicConfig, endpoint: String, params: [String: String]) -> URL {
        let serverUrl = config.serverUrl
        let baseUrl: String = "\(serverUrl)/rest/\(endpoint).view"
        
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
