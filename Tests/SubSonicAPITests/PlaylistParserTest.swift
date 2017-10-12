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
        
        parser.onComplete = { (results, error) in
            guard let playlists = results?["playlists"] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            print("playlists count: \(playlists.count)")
            XCTAssert(playlists.count == 15)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONSingle() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "playlist-epic", fileExt: "json")
        let expect = expectation(description: "Parsing complete")

        parser.onComplete = { (results, error) in
            guard let playlists = results?["playlists"] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            print("playlists count: \(playlists.count)")
            XCTAssert(playlists.count == 1)
            
    
            guard let tracks = playlists[0].tracks else {
                XCTFail("Tracks not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 224)
            expect.fulfill()
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
        
        parser.onComplete = { (results, error) in
            guard let playlists = results?["playlists"] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            print("playlists count: \(playlists.count)")
            XCTAssert(playlists.count == 15)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
        print("Done waiting")
    }
    
    func testXMLSingle() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "playlist-epic", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let playlists = results?["playlists"] as? [Playlist] else {
                XCTFail("Playlists not found")
                return
            }
            print("playlists count: \(playlists.count)")
            XCTAssert(playlists.count == 1)
            
            guard let tracks = playlists[0].tracks else {
                XCTFail("Tracks not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 224)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
