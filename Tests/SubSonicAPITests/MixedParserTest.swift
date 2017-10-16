import XCTest
@testable import SubSonicAPI

class MixedParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONSearchList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "search-fire", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let tracks = results?[.Song] as? [Song] else {
                XCTFail("Songs not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 20)
            
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
            XCTAssert(artists.count == 1)
            
            expect.fulfill()
        }

        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONStarredList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "starred", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
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

        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }


    func testXMLSearchList() {
        let parser = XMLRequestParser()
        // Given a list of tracks query
        let xml = self.helper.getDataFromFile(fileName: "search-fire", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let tracks = results?[.Song] as? [Song] else {
                XCTFail("Songs not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 20)
            
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
            XCTAssert(artists.count == 1)
            
            expect.fulfill()
        }

        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testXMLStarredList() {
        let parser = XMLRequestParser()
        // Given a list of tracks query
        let xml = self.helper.getDataFromFile(fileName: "starred", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
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
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
