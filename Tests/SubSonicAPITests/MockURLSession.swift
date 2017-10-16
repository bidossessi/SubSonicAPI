//
//  Helpers.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import XCTest
@testable import SubSonicAPI

class MockURLSessionDownloadTask: URLSessionDownloadTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        self.resumeWasCalled = true
    }
}


class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        self.resumeWasCalled = true
    }
}

class MockRequestSession: URLSessionProtocol {
    func downloadTask(with url: URL) -> URLSessionDownloadTaskProtocol {
        return MockURLSessionDownloadTask()
    }
    
    var nextDataTask: URLSessionDataTaskProtocol = MockURLSessionDataTask()
    var nextError: Error?
    var nextResponse: URLResponse?
    var nextData: Data?
    private (set) var lastURL: URL?
    let helper = TestHelper()
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        let data = getData(url)
        let response = getResponse(url)
        completionHandler(data, response, nextError)
        return self.nextDataTask
    }
    
    // Fake API response
    private func findFormat(_ url: URL) -> String {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return "xml" }
        let formatArray = queryItems.filter({ $0.name == "f" })
        guard let format = formatArray.first else {
            return "xml"
        }
        return format.value!
    }
    
    // find view in URL and return data accordingly
    private func getData(_ url: URL) -> Data {
        if nextData != nil {
            return nextData!
        }
        // Match the url with
        let viewString: String = url.lastPathComponent.components(separatedBy: ".")[0]
        guard let view: Constants.SubSonicAPI.Views = Constants.SubSonicAPI.Views(rawValue: viewString) else {
            return "{}".data(using: .utf8)!
        }
        let ext = findFormat(url)
        switch view {
        case .RandomSongs:
            return self.helper.getDataFromFile(fileName: "randomsongs", fileExt: ext)
        case .Artists:
            return self.helper.getDataFromFile(fileName: "artists", fileExt: ext)
        case .Artist:
            return self.helper.getDataFromFile(fileName: "artist-gackt", fileExt: ext)
        case .Albums:
            return self.helper.getDataFromFile(fileName: "albumlist", fileExt: ext)
        case .Genres:
            return self.helper.getDataFromFile(fileName: "genres", fileExt: ext)
        case .Genre:
            return self.helper.getDataFromFile(fileName: "genre-kizomba", fileExt: ext)
        case .Playlists:
            return self.helper.getDataFromFile(fileName: "playlists", fileExt: ext)
        case .Starred:
            return self.helper.getDataFromFile(fileName: "starred", fileExt: ext)
        default:
            return "{}".data(using: .utf8)!
        }
    }
    
    private func getResponse(_ url: URL) -> URLResponse {
        if nextResponse != nil {
            return nextResponse!
        }
        return HTTPURLResponse(url: url, statusCode: 200,
                               httpVersion: nil, headerFields: nil)!
    }

}


