//
//  AlbumParserTest.swift
//  SubTrackTests
//
//  Created by Stanislas Sodonon on 9/27/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

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
        // Given a list of albums query
        let json = self.helper.getDataFromFile(fileName: "albumlist", fileExt: "json")
        let expect = expectation(description: "Parsing complete")
        
        parser.onComplete = { results in
            expect.fulfill()
        }
        
        // Parse
        parser.parse(data: json)
        
        waitForExpectations(timeout: 10, handler: nil)
        print("Done waiting")
    }
}
