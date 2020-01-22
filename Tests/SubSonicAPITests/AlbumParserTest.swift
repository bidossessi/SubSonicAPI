import XCTest
@testable import SubSonicAPI

class AlbumParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "albumlist", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let albums = results[.Album] as? [Album] else {
                    XCTFail("Albums not found")
                    return
                }
                XCTAssert(albums.count == 10)
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
        let json = self.helper.getDataFromFile(fileName: "album-chitose", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let albums = results[.Album] as? [Album] else {
                    XCTFail("Album not found")
                    return
                }
                XCTAssert(albums.count == 1)
                
                let tracks = albums[0].songs
                XCTAssert(tracks.count == 11)
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
        // Given a list of albums query
        let xml = self.helper.getDataFromFile(fileName: "albumlist", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let albums = results[.Album] as? [Album] else {
                    XCTFail("Albums not found")
                    return
                }
                print("albums count: \(albums.count)")
                XCTAssert(albums.count == 10)
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
        let json = self.helper.getDataFromFile(fileName: "album-chitose", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let albums = results[.Album] as? [Album] else {
                    XCTFail("Albums not found")
                    return
                }
                XCTAssert(albums.count == 1)
                
                let tracks = albums[0].songs
                XCTAssert(tracks.count == 11)
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
