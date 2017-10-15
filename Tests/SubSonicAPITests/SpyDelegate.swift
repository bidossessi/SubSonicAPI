//
//  Helpers.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import XCTest
@testable import SubSonicAPI


class SpyDelegate: SubSonicDelegate {
    let expect: XCTestExpectation
    let handler: QueryResult
    
    init (expectation: XCTestExpectation, handler: @escaping QueryResult) {
        self.expect = expectation
        self.handler = handler
    }
    
    func sub(_ client: SubSonicProtocol, endpoint: Constants.SubSonicAPI.Views) -> SubSonicConfig {
        return SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                         username: "myuser",
                         password: "mypassword",
                         format: .Xml)
    }
    
    func sub(_ client: SubSonicProtocol, endpoint: Constants.SubSonicAPI.Views, results: [Constants.SubSonicAPI.Results : [SubItem]]?, error: Error?) {
        handler(results, error)
        self.expect.fulfill()
    }
}
