import XCTest
@testable import SubSonicAPI

class DelegateRequestTest: XCTestCase {

    var subject: HTTPRequestClient!
    var api: SubSonicDataProtocol!
    var config: SubSonicConfig!
    let session = MockRequestSession()
    let helper = TestHelper()

    
    override func setUp() {
        super.setUp()
        subject = HTTPRequestClient(session: session)
        api = DataRequestAPI(client: subject)
    }
    
    func test_APIRandomSongQuery() {
        let expect = expectation(description: "Got Data")        
        func handle(_ results: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) {
            guard let tracks = results?[.Song] as? [Song] else {
                XCTFail("Songs not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 10)
        }
        
        let spyDelegate = RequestDelegate(expectation: expect, handler: handle)
        api.delegate = spyDelegate
        
        api.randomSongs()
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func test_APIArtistsQuery() {
        let expect = expectation(description: "Got Data")
        
        func handle(_ results: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) {
            guard let indexes = results?[.Index] as? [ArtistIndex] else {
                XCTFail("ArtistIndexes not found")
                return
            }
            print("indexes count: \(indexes.count)")
            XCTAssert(indexes.count == 25)
        }
        
        let spyDelegate = RequestDelegate(expectation: expect, handler: handle)
        api.delegate = spyDelegate
        
        api.artists()
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func test_APIGacktQuery() {
        let expect = expectation(description: "Got Data")
        
        func handle(_ results: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) {
            guard let artists = results?[.Artist] as? [Artist] else {
                XCTFail("Artists not found")
                return
            }
            print("indexes count: \(artists.count)")
            XCTAssert(artists.count == 1)
            
            let albums = artists[0].albums
            print("albums count: \(albums.count)")
            XCTAssert(albums.count == 8)
        }
        
        let spyDelegate = RequestDelegate(expectation: expect, handler: handle)
        api.delegate = spyDelegate
        
        api.artist(id: 100000578)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

}
