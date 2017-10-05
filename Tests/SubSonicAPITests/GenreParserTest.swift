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
        
        parser.onComplete = { results in
            guard let genres = results["genres"] as? [Genre] else {
                XCTFail("Genres not found")
                return
            }
            print("genres count: \(genres.count)")
            XCTAssert(genres.count == 157)
            expect.fulfill()
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
        
        parser.onComplete = { results in
            guard let genres = results["genres"] as? [Genre] else {
                XCTFail("Genres not found")
                return
            }
            print("genres count: \(genres.count)")
            XCTAssert(genres.count == 157 )
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: xml)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
