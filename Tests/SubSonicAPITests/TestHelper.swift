import XCTest
@testable import SubSonicAPI

class TestHelper {
    func getURLFor(fileName name: String, fileExt ext: String) -> URL {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            fatalError("\(name) not found")
        }
        return url
    }
    
    func getDataFromFile(fileName name: String, fileExt ext: String) -> Data {
        let url = getURLFor(fileName: name, fileExt: ext)
        guard let data = try? Data(contentsOf: url) else {
            fatalError("\(url.absoluteURL) not found")
        }
        return data
    }

    func generateRandomNumber(min: Int = 1, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
}

struct SubConfig: SubSonicConfig {
    let serverUrl: String
    let username: String
    let password: String
    let format: RequestFormat
}
