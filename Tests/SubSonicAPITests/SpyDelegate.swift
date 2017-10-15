//
//  Helpers.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import XCTest
@testable import SubSonicAPI


class RequestDelegate: SubSonicDelegate {
    var expect: XCTestExpectation?
    let handler: QueryResult
    
    init (expectation: XCTestExpectation, handler: @escaping QueryResult) {
        self.expect = expectation
        self.handler = handler
    }
    init (handler: @escaping QueryResult) {
        self.handler = handler
    }

    func config(_ client: URLBuilder) -> SubSonicConfig {
        return SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                         username: "myuser",
                         password: "mypassword",
                         format: .Xml)
    }
    
    func sub(_ client: SubSonicProtocol, endpoint: Constants.SubSonicAPI.Views, results: [Constants.SubSonicAPI.Results : [SubItem]]?, error: Error?) {
        handler(results, error)
        self.expect?.fulfill()
    }
}

class DownloadDelegate: SubSonicDownloadDelegate {
    var expect: XCTestExpectation?
    let handler: DownloadResult
    
    init (expectation: XCTestExpectation, handler: @escaping DownloadResult) {
        self.expect = expectation
        self.handler = handler
    }

    init (handler: @escaping DownloadResult) {
        self.handler = handler
    }

    func config(_ client: URLBuilder) -> SubSonicConfig {
        return SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                         username: "myuser",
                         password: "mypassword",
                         format: .Xml)
    }
    
    func sub(_ client: SubSonicDownloadProtocol,
             saveMedia download: Download?,
             error: Error?) -> Void {
        handler(download, error)
        self.expect?.fulfill()
    }

}
