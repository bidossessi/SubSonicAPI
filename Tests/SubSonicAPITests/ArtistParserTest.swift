import XCTest
@testable import SubSonicAPI

class ArtistParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "artists", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let indexes = results?["artistIndexes"] as? [ArtistIndex] else {
                XCTFail("ArtistIndexes not found")
                return
            }
            print("indexes count: \(indexes.count)")
            XCTAssert(indexes.count == 25)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONSingle() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "artist-gackt", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let artists = results?["artists"] as? [Artist] else {
                XCTFail("Artists not found")
                return
            }
            print("indexes count: \(artists.count)")
            XCTAssert(artists.count == 1)
            
            guard let albums = artists[0].albums else {
                XCTFail("Tracks not found")
                return
            }
            print("albums count: \(albums.count)")
            XCTAssert(albums.count == 8)
            expect.fulfill()
        }

        // Parse
        parser.parse(data: json)

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testXMLList() {
        let parser = XMLRequestParser()
        // Given a list of indexes query
        let xml = self.helper.getDataFromFile(fileName: "artists", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let indexes = results?["artistIndexes"] as? [ArtistIndex] else {
                XCTFail("ArtistIndexs not found")
                return
            }
            print("indexes count: \(indexes.count)")
            XCTAssert(indexes.count == 25)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
        print("Done waiting")
    }
    
    func testXMLSingle() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "artist-gackt", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let artists = results?["artists"] as? [Artist] else {
                XCTFail("Artists not found")
                return
            }
            print("indexes count: \(artists.count)")
            XCTAssert(artists.count == 1)
            
            guard let albums = artists[0].albums else {
                XCTFail("Tracks not found")
                return
            }
            print("albums count: \(albums.count)")
            XCTAssert(albums.count == 8)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
