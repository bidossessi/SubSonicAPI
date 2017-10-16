//
//  DownloadQueueTest.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/15/17.
//

import XCTest
@testable import SubSonicAPI

class FileDownloadTest: XCTestCase {

    var queue: DownloadQueueProtocol!
    var subject: MediaDownloadClientProtocol!
    var api: SubSonicDownloadProtocol!
    let helper = TestHelper()
    let builder = MockURLBuilder()

    override func setUp() {
        super.setUp()
        queue = DownloadQueue.shared
        subject = MediaDownloadClient()
        api = DownloadRequestAPI(client: subject, builder: builder)
    }
    override func tearDown() {
        super.tearDown()
        queue.clean()
    }
    
    func testDownloadOne() {
        let expect = expectation(description: "Got Data")

        func handle(_ d: Download?, _ e: Error?){
            XCTAssertNil(e)
            XCTAssertNotNil(d)
        }
        
        let spyDelegate = DownloadDelegate(unitExpect: expect, handler: handle)
        api.delegate = spyDelegate

        let s = Song.generate()
        api.download(song: s)
        waitForExpectations(timeout: 3, handler: nil)
    }


    func testDownloadMulti() {
        let expect = expectation(description: "All Collected")
        let arr = 1...5
        let s = arr.map{ i in Song.generate(i) }
        var collect = Set<Download>()
        
        func handle(_ d: Download?, _ e: Error?){
            XCTAssertNil(e)
            XCTAssertNotNil(d)
            XCTAssertEqual(d?.state, .Completed)
            XCTAssertFalse(collect.contains(d!))
            collect.insert(d!)
        }
        
        let spyDelegate = DownloadDelegate(completeExpect: expect, handler: handle)
        api.delegate = spyDelegate
        
        api.download(songs: s)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(collect.count, arr.count)
    }

}
