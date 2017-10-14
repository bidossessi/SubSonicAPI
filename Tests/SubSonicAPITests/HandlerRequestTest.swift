import XCTest
@testable import SubSonicAPI

class HandlerRequestTest: XCTestCase {

    var subject: HTTPRequestClient!
    var api: SubSonicProtocol!
    var config: SubSonicConfig!
    let session = MockRequestSession()
    let helper = TestHelper()

    
    override func setUp() {
        super.setUp()
        subject = HTTPRequestClient(session: session)
        api = DataRequestAPI(client: subject)
        config = SubConfig(serverUrl: "http://mysubsonicserver.com:8989",
                           username: "myuser",
                           password: "mypassword",
                           format: .Json)
    }
    
    func test_APIFunctionalQuery() {
        let expectedData = self.helper.getDataFromFile(fileName: "randomsongs", fileExt: "json")
        let url = URL(string: config.serverUrl)!
        session.nextResponse = HTTPURLResponse(url: url,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
        session.nextData = expectedData
        let expect = expectation(description: "Got Data")
        
        func handler(_ results: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) {
            guard let tracks = results?[.Song] as? [Song] else {
                XCTFail("Songs not found")
                return
            }
            print("tracks count: \(tracks.count)")
            XCTAssert(tracks.count == 10)
            expect.fulfill()
        }

        api.randomSongs(config: config, resultHandler: handler)
        
        waitForExpectations(timeout: 3, handler: nil)

    }
}
