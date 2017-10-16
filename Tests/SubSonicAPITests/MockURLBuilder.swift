import XCTest
@testable import SubSonicAPI

class MockURLBuilder: URLBuilderProtocol {
    
    func url(config: SubSonicConfig, endpoint: Constants.SubSonicAPI.Views, params: [String: String]) -> URL {
        let serverUrl = config.serverUrl
        let baseUrl: String = "\(serverUrl)/rest/\(endpoint.rawValue).view"
        
        let defaultParams: [String: String] = [
            "u": config.username,
            "p": config.password,
            "c": Constants.SubSonicInfo.apiName,
            "v": Constants.SubSonicInfo.apiVersion,
            "f": config.format.rawValue
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
    
    func url(config: SubSonicConfig, urlForMedia id: String) -> URL {
        // return a file url
        let helper = TestHelper()
        let map = ["artists", "playlist-epic", "randomsongs", "playlists", "genres", "starred", "albumlist"]
        let index = Int(id)!
        print(index)
        let url = helper.getURLFor(fileName: map[index], fileExt: "json")
//        print("download: \(url)")
        return url
    }
    
    func url(config: SubSonicConfig, urlForCover id: String) -> URL {
        // return a file url
        let helper = TestHelper()
        let url = helper.getURLFor(fileName: "artists", fileExt: "json")
//        print("download: \(url)")
        return url
    }
}

