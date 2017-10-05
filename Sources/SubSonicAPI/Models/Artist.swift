import Foundation

class Artist: Hashable, SubItem {
    let id: Int
    var name: String
    var coverArt: String?
    var albumCount: Int?
    var albums: [Album]?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func populate(_ data: [String: Any]) -> Artist {
        let id = makeInt(data["id"])!
        let name = data["name"] as! String
        let mo = Artist(id: id, name: name)
        mo.albumCount = makeInt(data["albumCount"])
        mo.coverArt = data["coverArt"] as? String
        if let albums = data[Constants.SubSonicAPI.Results.Album] as? [[String: Any]] {
            mo.albums = Album.populate(albums)
        }
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> [Artist] {
        return array.map { Artist.populate($0) }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return id
    }
    static func ==(lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

}
