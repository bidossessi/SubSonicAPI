//
//  Helpers.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/5/17.
//

import Foundation
@testable import SubSonicAPI

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        self.resumeWasCalled = true
    }
}

class MockRequestSession: URLSessionProtocol {
    var nextDataTask: URLSessionDataTaskProtocol = MockURLSessionDataTask()
    var nextError: Error?
    var nextResponse: URLResponse?
    var nextData: Data?
    private (set) var lastURL: URL?
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, nextResponse, nextError)
        return nextDataTask
    }
    
}


