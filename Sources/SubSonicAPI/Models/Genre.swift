import Foundation

final class Genre: Hashable, SubItem {
    var name: String
    var songCount, albumCount: Int?
    
    init(name: String) {
        self.name = name.capitalized
    }
    
    class func populate(_ data: [String: Any]) -> Genre {
        let name = data["value"] as! String
        let mo = Genre(name: name)
        if let songCount = data["songCount"] as? NSNumber {
            mo.songCount = songCount.intValue
        }
        if let albumCount = data["albumCount"] as? NSNumber {
            mo.albumCount = albumCount.intValue
        }
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


