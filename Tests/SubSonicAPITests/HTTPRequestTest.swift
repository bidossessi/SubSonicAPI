//
//  RequestTest.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/14/17.
//

import XCTest
@testable import SubSonicAPI

class HTTPRequestTest: XCTestCase {

    var subject: HTTPRequestCLientProtocol!
    let session = MockRequestSession()

    
    override func setUp() {
        super.setUp()
        subject = HTTPRequestClient(session: session)
    }
    
    func test_QueryRequestsTheURL() {
        let url = URL(string: "http://mysubsonicserver.com")!
        
        subject.query(url)
        
        XCTAssert(session.lastURL == url)
    }

    func test_QueryStartsTheRequest() {
        let url = URL(string: "http://mysubsonicserver.com")!
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        subject.query(url)
        
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_QueryReturnsData() {
        let url = URL(string: "http://mysubsonicserver.com")!
        let expectedData = "{}".data(using: .utf8)
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200,
                                               httpVersion: nil, headerFields: nil)
        session.nextData = expectedData
        let expect = expectation(description: "Got Data")
        
        subject.onComplete = { (data, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            XCTAssertEqual(data, expectedData)
            expect.fulfill()
        }

        subject.query(url)
        
        waitForExpectations(timeout: 3, handler: nil)

    }
    
    func test_QueryWithANetworkError_ReturnsANetworkError() {
        let url = URL(string: "http://mysubsonicserver.com")!
        session.nextError = NSError(domain: "error", code: 0, userInfo: nil)
        let expect = expectation(description: "Got Error")
        
        subject.onComplete = { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, NetworkError.Query)
            expect.fulfill()
        }
        subject.query(url)

        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_QueryWithAStatusCodeLessThan200_ReturnsAnError() {
        let url = URL(string: "http://mysubsonicserver.com")!
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 199,
                                               httpVersion: nil, headerFields: nil)
        let expect = expectation(description: "Got Error")
        
        subject.onComplete = { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, NetworkError.Response(code: 199))
            expect.fulfill()
        }

        subject.query(url)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_QueryWithAStatusCodeGreaterThan299_ReturnsAnError() {
        let url = URL(string: "http://mysubsonicserver.com")!
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 300,
                                               httpVersion: nil, headerFields: nil)
        let expect = expectation(description: "Got Error")
        
        subject.onComplete = { (data, error) in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertEqual(error, NetworkError.Response(code: 300))
            expect.fulfill()
        }
        
        subject.query(url)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
