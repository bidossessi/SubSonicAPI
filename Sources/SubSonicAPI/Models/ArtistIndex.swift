import Foundation

class ArtistIndex: Hashable, SubItem {
    var name: String
    var artists: [Artist]?

    init(name: String) {
        self.name = name
    }
    
    convenience init(attrs: [String: String]) {
        self.init(name: attrs["name"]!)
    }
    
    class func populate(_ data: [String: Any]) -> ArtistIndex {
        let name = data["name"] as! String
        let mo = ArtistIndex(name: name)
        if let artists = data[Constants.SubSonicAPI.Results.Artist] as? [[String: Any]] {
            mo.artists = Artist.populate(artists)
        }
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> [ArtistIndex] {
        return array.map { ArtistIndex.populate($0) }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return name.hashValue * 5
    }

    static func ==(lhs: ArtistIndex, rhs: ArtistIndex) -> Bool {
        return lhs.name == rhs.name
    }

}


