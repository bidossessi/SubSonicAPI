//
//  Helpers.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import XCTest
@testable import SubSonicAPI


class RequestDelegate: SubSonicDataDelegate {
    
    var expect: XCTestExpectation?
    let handler: QueryResult
    
    init (expectation: XCTestExpectation, handler: @escaping QueryResult) {
        self.expect = expectation
        self.handler = handler
    }
    init (handler: @escaping QueryResult) {
        self.handler = handler
    }

    func config(_ client: SubSonicProtocol) -> SubSonicConfig {
        return SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                         username: "myuser",
                         password: "mypassword",
                         format: .Xml)
    }
    
    func sub(_ client: SubSonicDataProtocol, endpoint: Constants.SubSonicAPI.Views, results: [Constants.SubSonicAPI.Results : [SubItem]]?, error: Error?) {
        handler(results, error)
        self.expect?.fulfill()
    }
}

class DownloadDelegate: SubSonicDownloadDelegate {
    var unitExpect: XCTestExpectation?
    var completeExpect: XCTestExpectation?
    let handler: DownloadResult
    
    init (unitExpect: XCTestExpectation, handler: @escaping DownloadResult) {
        self.unitExpect = unitExpect
        self.handler = handler
    }
    init (completeExpect: XCTestExpectation, handler: @escaping DownloadResult) {
        self.completeExpect = completeExpect
        self.handler = handler
    }

    init (handler: @escaping DownloadResult) {
        self.handler = handler
    }

    func config(_ client: SubSonicProtocol) -> SubSonicConfig {
        return SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                         username: "myuser",
                         password: "mypassword",
                         format: .Xml)
    }
    
    func sub(_ client: SubSonicDownloadProtocol,
             saveMedia download: Download?,
             error: Error?) -> Void {
        handler(download, error)
        self.unitExpect?.fulfill()
    }

    func queueEmpty(_ client: SubSonicDownloadProtocol) -> Void {
        self.completeExpect?.fulfill()
    }

}
