import XCTest
@testable import SubSonicAPI

class InvalidParserTest: XCTestCase {
    
    let helper = TestHelper()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONSerializationError() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "invalid", fileExt: "txt")
        let expect = expectation(description: "Error found")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Serialization)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONEnvelopError() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "envelop-error", fileExt: "json")
        let expect = expectation(description: "Error found")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Envelop)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONVersionError() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "version-error", fileExt: "json")
        let expect = expectation(description: "Error found")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Version(found: "a", minimum: "b"))
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testJSONStatusError() {
        let parser = JSONRequestParser()
        let json = self.helper.getDataFromFile(fileName: "failed", fileExt: "json")
        let expect = expectation(description: "Error found")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Status(code: 40, message: "a"))
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testXMLSerializationError() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "invalid", fileExt: "txt")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Serialization)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testXMLEnvelopError() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "envelop-error", fileExt: "xml")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Envelop)
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testXMLVersionError() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "version-error", fileExt: "xml")
        let expect = expectation(description: "Error found")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Version(found: "a", minimum: "b"))
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testXMLStatusError() {
        let parser = XMLRequestParser()
        let json = self.helper.getDataFromFile(fileName: "failed", fileExt: "xml")
        let expect = expectation(description: "Error found")
        
        parser.onComplete = { (results, error) in
            XCTAssertNil(results)
            XCTAssertNotNil(error)
            XCTAssertEqual(error!, ParsingError.Status(code: 40, message: "a"))
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    

}
