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
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let indexes = results[.Index] as? [ArtistIndex] else {
                    XCTFail("ArtistIndexes not found")
                    return
                }
                XCTAssert(indexes.count == 25)
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
        let json = self.helper.getDataFromFile(fileName: "artist-gackt", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let artists = results[.Artist] as? [Artist] else {
                    XCTFail("Artists not found")
                    return
                }
                XCTAssert(artists.count == 1)
                
                let albums = artists[0].albums
                XCTAssert(albums.count == 8)
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
        // Given a list of indexes query
        let xml = self.helper.getDataFromFile(fileName: "artists", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let indexes = results[.Index] as? [ArtistIndex] else {
                    XCTFail("ArtistIndexs not found")
                    return
                }
                XCTAssert(indexes.count == 25)
                expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
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
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let artists = results[.Artist] as? [Artist] else {
                    XCTFail("Artists not found")
                    return
                }
                XCTAssert(artists.count == 1)
                
                let albums = artists[0].albums
                XCTAssert(albums.count == 8)
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
