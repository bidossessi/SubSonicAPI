import XCTest
@testable import SubSonicAPI

class HandlerRequestTest: XCTestCase {

    var subject: HTTPRequestClient!
    var api: SubSonicProtocol!
    var config: SubSonicConfig!
    let session = MockRequestSession()
    let helper = TestHelper()

    
    override func setUp() {
        super.setUp()
        subject = HTTPRequestClient(session: session)
        api = DataRequestAPI(client: subject)
        config = SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                           username: "myuser",
                           password: "mypassword",
                           format: .Json)
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
            expect.fulfill()
        }
        api.randomSongs(config: config, resultHandler: handle)
        
        waitForExpectations(timeout: 3, handler: nil)

    }

    func test_APIKizombaQuery() {
        let expect = expectation(description: "Got Data")
        
        func handle(_ results: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) {
            guard let tracks = results?[.Song] as? [Song] else {
                XCTFail("Songs not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 98)
            expect.fulfill()
        }
        api.genre(name: "kizomba", config: config, resultHandler: handle)
        
        waitForExpectations(timeout: 3, handler: nil)
        
    }

    func test_APIStarredQuery() {
        let expect = expectation(description: "Got Data")
        
        func handle(_ results: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) {
            guard let tracks = results?[.Song] as? [Song] else {
                XCTFail("Songs not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 97)
            
            guard let albums = results?[.Album] as? [Album] else {
                XCTFail("Albums not found")
                return
            }
            print("albums count: \(albums.count)")
            XCTAssert(albums.count == 2)
            
            guard let artists = results?[.Artist] as? [Artist] else {
                XCTFail("Artists not found")
                return
            }
            print("artists count: \(artists.count)")
            XCTAssert(artists.count == 2)
            expect.fulfill()
        }
        api.starred(config: config, resultHandler: handle)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

}
