import XCTest
@testable import SubSonicAPI

class TrackParserTest: XCTestCase {
    
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
        
        parser.onComplete = { (results, error) in
            guard let tracks = results?[.Track] as? [Track] else {
                XCTFail("Tracks not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 10)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }


    func testXMLList() {
        let parser = XMLRequestParser()
        // Given [.Track] list of tracks query
        let xml = self.helper.getDataFromFile(fileName: "randomsongs", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            guard let tracks = results?[.Track] as? [Track] else {
                XCTFail("Tracks not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 10 )
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}