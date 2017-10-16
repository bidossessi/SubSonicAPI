import XCTest
@testable import SubSonicAPI

extension Song {
    class func generate(_ id: Int = 1) -> Song {
        let uuid = UUID()
        return Song(id: id, title: uuid.uuidString, path: uuid.uuidString)
    }
}

