import Foundation

class Album: Hashable, SubItem {
    
    let id: Int
    var name: String
    var artist, title, album, genre, coverArt: String?
    var parent, songCount, duration, artistId, year: Int?
    var tracks: [Song]?
    
    var decription: String {
        return "\(id): \(name)"
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func populate(_ data: [String: Any]) -> Album {
        
        let id = makeInt(data["id"])!
        let name = data["name"] as! String
        let mo = Album(id: id, name: name)

        if let parent = data["parent"] as? NSNumber {
            mo.parent = parent.intValue
        }
        mo.artistId = makeInt(data["artistId"])!
        mo.songCount = makeInt(data["songCount"])!
        mo.duration = makeInt(data["songCount"])!
        mo.year = makeInt(data["year"])
        mo.artist = data["artist"] as? String
        mo.album = data["album"] as? String
        mo.genre = data["genre"] as? String
        mo.coverArt = data["coverArt"] as? String
        mo.title = data["title"] as? String
        if let tracks = data[Constants.SubSonicAPI.Results.Song.rawValue] as? [[String: Any]] {
            mo.tracks = Song.populate(tracks)
        }
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> [Album] {
        return array.map { Album.populate($0) }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return id
    }
    static func ==(lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

}

