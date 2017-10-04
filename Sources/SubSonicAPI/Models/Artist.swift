import Foundation

class Artist: Hashable {
    let id: Int
    var name: String
    var coverArt: String?
    var albumCount: Int?
    var albums: Set<Album>?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func populate(_ data: [String: Any]) -> Artist {
        let id = data["id"] as! NSNumber
        let name = data["name"] as! String
        let mo = Artist(id: id.intValue, name: name)
        if let albumCount = data["albumCount"] as? NSNumber {
            mo.albumCount = albumCount.intValue
        }
        mo.coverArt = data["coverArt"] as? String
        if let albums = data[Constants.SubSonicAPI.Results.Album] as? [[String: Any]] {
            mo.albums = Album.populate(albums)
        }
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> Set<Artist> {
        let datas = array.map { Artist.populate($0) }
        return Set<Artist>(datas)
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return id
    }
    static func ==(lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

}
