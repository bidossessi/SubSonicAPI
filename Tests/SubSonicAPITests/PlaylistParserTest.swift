import XCTest
@testable import SubSonicAPI

class PlaylistParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "playlists", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
       parser.onComplete = { (res) in
        switch res {
        case .success(let results):
            guard let playlists = results[.Playlist] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            XCTAssert(playlists.count == 15)
            expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONSingle() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "playlist-epic", fileExt: "json")
        let expect = expectation(description: "Parsing complete")

        parser.onComplete = { (res) in
        switch res {
        case .success(let results):
            guard let playlists = results[.Playlist] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            XCTAssert(playlists.count == 1)
            
    
            let tracks = playlists[0].songs
            XCTAssert(tracks.count == 224)
            expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
        }

        // Parse
        parser.parse(data: json)

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testXMLList() {
        let parser = XMLRequestParser()
        // Given a list of playlists query
        let xml = self.helper.getDataFromFile(fileName: "playlists", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
       parser.onComplete = { (res) in
        switch res {
        case .success(let results):
            guard let playlists = results[.Playlist] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            XCTAssert(playlists.count == 15)
            expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
            
        }
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testXMLSingle() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "playlist-epic", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
       parser.onComplete = { (res) in
        switch res {
        case .success(let results):
            guard let playlists = results[.Playlist] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            XCTAssert(playlists.count == 1)
            
            let tracks = playlists[0].songs
            XCTAssert(tracks.count == 224)
            expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
