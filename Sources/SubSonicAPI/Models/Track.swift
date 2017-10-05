import Foundation


class Track: Hashable, SubItem {

    let id: Int
    let title, path: String
    var artist, album, suffix, contentType, genre, coverArt: String?
    var parent, track, albumId, artistId, bitRate, size, duration, year, rating: Int?

    init(
        id: Int,
        title: String,
        path: String) {
        
        self.title = title
        self.path = path
        self.id = id
    }
    
    class func populate(_ data: [String: Any]) -> Track {
        let id = makeInt(data["id"])!
        let title = data["title"] as! String
        let path = data["path"] as! String
        let mo = Track(id: id, title: title, path: path)

        mo.track = makeInt(data["track"])
        mo.parent = makeInt(data["parent"])
        mo.albumId = makeInt(data["albumId"])!
        mo.artistId = makeInt(data["artistId"])!
        mo.size = makeInt(data["size"])!
        mo.bitRate = makeInt(data["bitRate"])!
        mo.duration = makeInt(data["duration"])!
        mo.year = makeInt(data["year"])
        
        mo.artist = data["artist"] as? String
        mo.album = data["album"] as? String
        mo.genre = data["genre"] as? String
        mo.coverArt = data["coverArt"] as? String
        mo.contentType = data["contentType"] as? String
        mo.suffix = data["suffix"] as? String
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> [Track] {
        return array.map { Track.populate($0) }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return id
    }
    static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id && lhs.path == rhs.path
    }

}


