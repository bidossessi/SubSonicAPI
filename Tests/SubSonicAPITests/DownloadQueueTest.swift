//
//  DownloadQueueTest.swift
//  SubSonicAPITests
//
//  Created by Stanislas Sodonon on 10/15/17.
//

import XCTest
@testable import SubSonicAPI

class DownloadQueueTest: XCTestCase {

    var queue: DownloadQueueProtocol!
    var subject: MediaDownloadClientProtocol!
    var api: SubSonicDownloadProtocol!
    let session = MockRequestSession()
    let helper = TestHelper()

    override func setUp() {
        super.setUp()
        queue = DownloadQueue.shared
        subject = MediaDownloadClient(session: session)
        api = DownloadRequestAPI(client: subject)
    }
    override func tearDown() {
        super.tearDown()
        queue.clean()
    }
    
    func testEnqueueOne() {
        func handle(_: Download?, _: Error?){}
        let spyDelegate = DownloadDelegate(handler: handle)
        api.delegate = spyDelegate

        let s = Song.generate()
        api.download(song: s)
        XCTAssertEqual(queue.remains, 1)
        guard let download = queue.next() else {
            XCTFail("Couldn't get song back from queue")
            return
        }
        XCTAssertEqual(download.state, .Pending)
        XCTAssertEqual(s, download.item)
        XCTAssertEqual(queue.remains, 1)
        
        download.state = .Completed
        let _ = queue.next()
        XCTAssertEqual(queue.remains, 0)

    }

    func testEnqueueRemovesCompleted() {
        func handle(_: Download?, _: Error?){}
        let spyDelegate = DownloadDelegate(handler: handle)
        api.delegate = spyDelegate
        
        let arr = 1...5
        let s = arr.map{ i in Song.generate(i) }
        api.download(songs: s)
        guard let download1 = queue.next() else {
            XCTFail("Couldn't get song back from queue")
            return
        }
        XCTAssertEqual(download1.state, .Pending)

        guard let download2 = queue.next() else {
            XCTFail("Couldn't get song back from queue")
            return
        }
        XCTAssertEqual(download2, download1)

        download1.state = .Completed

        guard let download3 = queue.next() else {
            XCTFail("Couldn't get song back from queue")
            return
        }
        XCTAssertNotEqual(download3, download1)
    }

    func testEnqueueHoldsOnLongDownloads() {
        func handle(_: Download?, _: Error?){}
        let spyDelegate = DownloadDelegate(handler: handle)
        api.delegate = spyDelegate
        
        let arr = 1...5
        let s = arr.map{ i in Song.generate(i) }
        api.download(songs: s)
        XCTAssertEqual(queue.remains, 5)
        let next1 = queue.next()
        XCTAssertNotNil(next1)
        next1?.state = .Completed
        
        let next2 = queue.next()
        XCTAssertNotNil(next2)
        XCTAssertEqual(queue.remains, 4)
        next2?.state = .Completed
        
        let next3 = queue.next()
        XCTAssertNotNil(next3)
        XCTAssertEqual(queue.remains, 3)
        next3?.state = .Downloading
        
        let next4 = queue.next()
        XCTAssertNil(next4)
        XCTAssertEqual(queue.remains, 3)
        
        let next5 = queue.next()
        XCTAssertNil(next5)
        XCTAssertEqual(queue.remains, 3)
        next3?.state = .Completed
        
        let next6 = queue.next()
        XCTAssertNotNil(next6)
        XCTAssertEqual(queue.remains, 2)
    }

}
