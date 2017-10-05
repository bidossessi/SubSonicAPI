import Foundation

class Album: Hashable, SubItem {
    
    let id: Int
    var name: String
    var artist, title, album, genre, coverArt: String?
    var parent, songCount, duration, artistId, year: Int?
    var tracks: [Track]?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func populate(_ data: [String: Any]) -> Album {
        let id = data["id"] as! NSNumber
        let name = data["name"] as! String
        let mo = Album(id: id.intValue, name: name)
        
        if let parent = data["parent"] as? NSNumber {
            mo.parent = parent.intValue
        }
        let artistId = data["artistId"] as! NSNumber
        mo.artistId = artistId.intValue
        let songCount = data["songCount"] as! NSNumber
        mo.songCount = songCount.intValue
        let duration = data["duration"] as! NSNumber
        mo.duration = duration.intValue
        if let year = data["year"] as? NSNumber {
            mo.year = year.intValue
        }
        mo.artist = data["artist"] as? String
        mo.album = data["album"] as? String
        mo.genre = data["genre"] as? String
        mo.coverArt = data["coverArt"] as? String
        mo.title = data["title"] as? String
        if let tracks = data[Constants.SubSonicAPI.Results.Track] as? [[String: Any]] {
            mo.tracks = Track.populate(tracks)
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

