import Foundation

enum ParsingError: Error, Equatable {
    case Serialization
    case Envelop
    case Version(found: String, minimum: String)
    case Status(code: Int, message: String)
}

func ==(lhs: ParsingError, rhs: ParsingError) -> Bool {
    switch (lhs, rhs) {
    case (.Serialization, .Serialization):
        return true
    case (.Envelop, .Envelop):
        return true
    case (.Version, .Version):
        return true
    case (.Status(code: let lcode, message: _), .Status(code: let rcode, message: _)):
        return lcode == rcode
    default:
        return false
    }
}


protocol RequestParser: class {
    func validate(version: String) throws
    func parse(data: Data)
    var onComplete: ((Result<[Constants.SubSonicAPI.Results: [SubItem]], ParsingError>) ->())? { get set }
}

extension RequestParser {
    
    func validate(version: String) throws {
        let apiVersion = NSString(string: Constants.SubSonicInfo.apiVersion)
        let options = NSString.CompareOptions.numeric
        let r = apiVersion.compare(version, options: options)
        if r == ComparisonResult.orderedDescending {
            throw ParsingError.Version(found: version, minimum: Constants.SubSonicInfo.apiVersion)
        }
    }
    
    static func getAsList(_ value: Any?) -> [[String: Any]]? {
        if let result = value as? [String: Any] {
            return [result]
        } else if let result = value as? [[String: Any]] {
            return result
        }
        return nil
    }
    
    static func getAsDict(_ value: Any?) -> [String: Any]? {
        if let result = value as? [String: Any] {
            return result
        }
        return nil
    }

    static func getListFromDict(key: Constants.SubSonicAPI.Results, data: Any?) -> [[String: Any]]? {
        if let dataDict = getAsDict(data) {
            return dataDict[key.rawValue] as? [[String: Any]]
        }
        return nil
    }
    
    static func makeInt(_ unknown: Any?) -> Int? {
        if let fromNS = unknown as? NSNumber {
          return fromNS.intValue
        } else if let fromStr = unknown as? String {
            return Int(fromStr)
        }
        return nil
    }

    static func populate(song data: [String: Any]) -> Song {
        return Song(
            id: makeInt(data["id"])!,
            title: data["title"] as! String,
            path: data["path"] as! String,
            artist: data["artist"] as? String,
            album: data["album"] as? String,
            suffix: data["genre"] as? String,
            contentType: data["coverArt"] as? String,
            genre: data["contentType"] as? String,
            coverArt: data["suffix"] as? String,
            track: makeInt(data["track"]),
            parent: makeInt(data["parent"]),
            albumId: makeInt(data["albumId"])!,
            artistId: makeInt(data["artistId"])!,
            bitRate: makeInt(data["size"])!,
            size: makeInt(data["bitRate"])!,
            duration: makeInt(data["duration"])!,
            year: makeInt(data["year"]),
            rating: makeInt(data["rating"])
        )
    }
    
    static func populate(songs array: [[String: Any]]) -> [Song] {
        return array.map { populate(song: $0) }
    }
    
    static func populate(album data: [String: Any]) -> Album {
        var matchedSongs: [Song] = []
        if  let songs = data[Constants.SubSonicAPI.Results.Song.rawValue] as? [[String: Any]] {
            matchedSongs = populate(songs: songs)
        }
        return Album(
            id: makeInt(data["id"])!,
            name: data["name"] as! String,
            artist: data["artist"] as? String,
            title: data["title"] as? String,
            genre: data["genre"] as? String,
            coverArt: data["coverArt"] as? String,
            songCount: makeInt(data["songCount"])!,
            duration: makeInt(data["duration"])!,
            artistId: makeInt(data["artistId"])!,
            year: makeInt(data["year"]),
            songs: matchedSongs
        )        
    }
    
    static func populate(albums array: [[String: Any]]) -> [Album] {
        return array.map { populate(album: $0) }
    }
    static func populate(artist data: [String: Any]) -> Artist {
        var matchedAlbums: [Album] = []
        if let albums = data[Constants.SubSonicAPI.Results.Album.rawValue] as? [[String: Any]] {
            matchedAlbums = populate(albums: albums)
        }
        return Artist(
            id: makeInt(data["id"])!,
            name: data["name"] as! String,
            coverArt: data["coverArt"] as? String,
            albumCount: makeInt(data["albumCount"]),
            albums: matchedAlbums
        )
    }
    
    static func populate(artists array: [[String: Any]]) -> [Artist] {
        return array.map { populate(artist: $0) }
    }
    
    static func populate(artistIndex data: [String: Any]) -> ArtistIndex {
        var matchedArtists: [Artist] = []
        if let artists = data[Constants.SubSonicAPI.Results.Artist.rawValue] as? [[String: Any]] {
         matchedArtists = populate(artists: artists)
        }
        return ArtistIndex(name: data["name"] as! String, artists: matchedArtists)
   }
       
   static func populate(artistIndices array: [[String: Any]]) -> [ArtistIndex] {
        return array.map { populate(artistIndex: $0) }
   }

    static func populate(genre data: [String: Any]) -> Genre {
        let fetchedName = data["value"] as? String
        let name = fetchedName?.capitalized ?? "Unknown"
        return Genre(
            name: name,
            songCount: makeInt(data["songCount"]),
            albumCount: makeInt(data["albumCount"])
        )
    }
    
    static func populate(genres array: [[String: Any]]) -> [Genre] {
        return array.map { populate(genre: $0) }
    }
    
    static func populate(playlist data: [String: Any]) -> Playlist {
        var matchedSongs: [Song] = []
        if let entries = data[Constants.SubSonicAPI.Results.Entry.rawValue] as? [[String: Any]] {
            let songEntries = entries.filter { !($0["isVideo"] as! Bool) }
            matchedSongs = populate(songs: songEntries)
        }
        return Playlist(
            id: makeInt(data["id"])!,
            name: data["name"] as! String,
            songCount: makeInt(data["songCount"]),
            duration: makeInt(data["duration"]),
            songs: matchedSongs
        )
    }
    
    static func populate(playlists array: [[String: Any]]) -> [Playlist] {
        return array.map { populate(playlist: $0) }
    }
}
