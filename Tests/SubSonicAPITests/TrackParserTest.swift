import XCTest
@testable import SubSonicAPI

class SongParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONList() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "randomsongs", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let tracks = results[.Song] as? [Song] else {
                    XCTFail("Songs not found")
                    return
                }
                XCTAssert(tracks.count == 10)
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
        // Given [.Song] list of tracks query
        let xml = self.helper.getDataFromFile(fileName: "randomsongs", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (res) in
            switch res {
            case .success(let results):
                guard let tracks = results[.Song] as? [Song] else {
                    XCTFail("Songs not found")
                    return
                }
                XCTAssert(tracks.count == 10 )
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
