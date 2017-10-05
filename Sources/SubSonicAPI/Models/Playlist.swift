import Foundation

class Playlist: Hashable, SubItem {
    var id: Int
    var name: String
    var songCount, duration: Int?
    var tracks: [Track]?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    class func populate(_ data: [String: Any]) -> Playlist {
        let id = data["id"] as! NSNumber
        let name = data["name"] as! String
        let mo = Playlist(id: id.intValue, name: name)
        if let songCount = data["songCount"] as? NSNumber {
            mo.songCount = songCount.intValue
        }
        if let duration = data["duration"] as? NSNumber {
            mo.duration = duration.intValue
        }
        if let entries = data[Constants.SubSonicAPI.Results.Entry] as? [[String: Any]] {
            let filteredEntries = entries.filter { !($0["isVideo"] as! Bool) }
            mo.tracks = Track.populate(filteredEntries)
        }
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> [Playlist] {
        return array.map { Playlist.populate($0) }
    }

    // MARK: - Hashable
    var hashValue: Int {
        return id
    }
    static func ==(lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}


