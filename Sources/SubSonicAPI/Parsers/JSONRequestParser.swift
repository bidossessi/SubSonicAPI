import Foundation


class JSONRequestParser: RequestParser {
    
    var onComplete: ((_ result: [String: [SubItem]]?, _ error: ParsingError?) ->())?

    init() {
        print("JSONRequestParser started")
    }

    func parse(data: Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            self.onComplete?(nil, ParsingError.Serialization)
            return
        }
        
        guard let response = json?[Constants.SubSonicInfo.apiResponse] as? [String: Any] else {
            self.onComplete?(nil, ParsingError.Envelop)
            return
        }
        // handle response
        do {
            try self.check(response)
            let dups = response.map({(k: String, v: Any?) in JSONRequestParser.extract(key: k, data: v)}).flatMap{ $0 }
            let results = Dictionary(uniqueKeysWithValues: dups)
            self.onComplete?(results, nil)
        } catch {
            let found = error as! ParsingError
            self.onComplete?(nil, found)
        }
            
    }
    
    private static func extract(key: String, data: Any?) -> [(String, [SubItem])] {
        switch key {
        case Constants.SubSonicAPI.Results.Track:
            if let items = JSONRequestParser.getAsList(data) {
                return [("tracks", Track.populate(items))]
            }

        case Constants.SubSonicAPI.Results.Album:
            if let items = JSONRequestParser.getAsList(data) {
                return [("albums", Album.populate(items))]
            }

        case Constants.SubSonicAPI.Results.Artist:
            if let items = JSONRequestParser.getAsList(data) {
                return [("artists", Artist.populate(items))]
            }

        case Constants.SubSonicAPI.Results.Index:
            if let items = JSONRequestParser.getAsList(data) {
                return [("artistIndexes", ArtistIndex.populate(items))]
            }

        case Constants.SubSonicAPI.Results.Playlist:
            if let items = JSONRequestParser.getAsList(data) {
                return [("playlists", Playlist.populate(items))]
            }

        case Constants.SubSonicAPI.Results.Genre:
            if let items = JSONRequestParser.getAsList(data) {
                return [("genres", Genre.populate(items))]
            }

        case Constants.SubSonicAPI.Results.SongsByGenre,
             Constants.SubSonicAPI.Results.RandomSongs:
            let items = JSONRequestParser.getListFromDict(key: Constants.SubSonicAPI.Results.Track, data: data)
            return JSONRequestParser.extract(key: Constants.SubSonicAPI.Results.Track, data: items)
            
        case Constants.SubSonicAPI.Results.Albums:
            let items = JSONRequestParser.getListFromDict(key: Constants.SubSonicAPI.Results.Album, data: data)
            return JSONRequestParser.extract(key: Constants.SubSonicAPI.Results.Album, data: items)
            
        case Constants.SubSonicAPI.Results.Artists:
            let items = JSONRequestParser.getListFromDict(key: Constants.SubSonicAPI.Results.Index, data: data)
            return JSONRequestParser.extract(key: Constants.SubSonicAPI.Results.Index, data: items)
            
        case Constants.SubSonicAPI.Results.Playlists:
            let items = JSONRequestParser.getListFromDict(key: Constants.SubSonicAPI.Results.Playlist, data: data)
            return JSONRequestParser.extract(key: Constants.SubSonicAPI.Results.Playlist, data: items)

        case Constants.SubSonicAPI.Results.Genres:
            let items = JSONRequestParser.getListFromDict(key: Constants.SubSonicAPI.Results.Genre, data: data)
            return JSONRequestParser.extract(key: Constants.SubSonicAPI.Results.Genre, data: items)

        case Constants.SubSonicAPI.Results.Search,
             Constants.SubSonicAPI.Results.Starred:
            let dataDict = JSONRequestParser.getAsDict(data)
            return dataDict!.map({(k: String, v: Any?) in JSONRequestParser.extract(key: k, data: v)}).flatMap{ $0 }
        default:
            return [(key, [])]
        }
        return [(key, [])]
    }
    
    private func check(_ dataObject: [String: Any]) throws {
        for (dataKey, data) in dataObject {
            switch dataKey {
            
            case Constants.SubSonicInfo.APIVersionAttr:
                try self.validate(version: data as! String)
                
            case Constants.SubSonicAPI.Results.Error:
                let dataDict = data as! [String: Any]
                let errorCode = dataDict["code"] as! Int
                let errorMsg = dataDict["message"] as! String
                throw ParsingError.Status(code: errorCode, message: errorMsg)
            default:
                print(dataKey)
            }
        }
        
    }

}
