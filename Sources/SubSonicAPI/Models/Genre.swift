import Foundation

final class Genre: Hashable, SubItem {
    var name: String = "Unknown"
    var songCount, albumCount: Int?
    
    
    class func populate(_ data: [String: Any]) -> Genre {
        let mo = Genre()
        if let name = data["value"] as? String {
            mo.name = name.capitalized
        }
        mo.songCount = makeInt(data["songCount"])
        mo.albumCount = makeInt(data["albumCount"])
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> [Genre] {
        return array.map { Genre.populate($0) }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return name.hashValue * 13
    }

    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        return lhs.name == rhs.name
    }
}


