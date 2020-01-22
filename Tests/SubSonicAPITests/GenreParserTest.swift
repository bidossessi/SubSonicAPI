import XCTest
@testable import SubSonicAPI

class GenreParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "genres", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let genres = results[.Genre] as? [Genre] else {
                    XCTFail("Genres not found")
                    return
                }
                XCTAssert(genres.count == 157)
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
        let json = self.helper.getDataFromFile(fileName: "genre-kizomba", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let tracks = results[.Song] as? [Song] else {
                    XCTFail("Songs not found")
                    return
                }
                XCTAssert(tracks.count == 98)
                expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    
    func testXMLList() {
        let parser = XMLRequestParser()
        // Given a list of genres query
        let xml = self.helper.getDataFromFile(fileName: "genres", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let genres = results[.Genre] as? [Genre] else {
                    XCTFail("Genres not found")
                    return
                }
                XCTAssert(genres.count == 157 )
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
        // Given a list of tracks query
        let xml = self.helper.getDataFromFile(fileName: "genre-kizomba", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let tracks = results[.Song] as? [Song] else {
                    XCTFail("Songs not found")
                    return
                }
                XCTAssert(tracks.count == 98 )
                expect.fulfill()
            default:
                XCTFail("Not supposed to fail")
            }
        }
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
