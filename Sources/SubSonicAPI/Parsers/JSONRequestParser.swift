import Foundation


class JSONRequestParser: RequestParser {
    var onComplete: ((_ result: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: ParsingError?) ->())?

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
            let dups = response.filter{ (k: String, _) in
                Constants.SubSonicAPI.Results(rawValue: k) != nil
            }.map{ (k: String, v: Any?) in
                JSONRequestParser.extract(key: Constants.SubSonicAPI.Results(rawValue: k)!, data: v)
            }.flatMap{ $0 }
            let results = Dictionary(uniqueKeysWithValues: dups)
            self.onComplete?(results, nil)
        } catch {
            let found = error as! ParsingError
            self.onComplete?(nil, found)
        }
            
    }
    
    class func extract(key: Constants.SubSonicAPI.Results, data: Any?) -> [(Constants.SubSonicAPI.Results, [SubItem])] {
        switch key {
        case .Track:
            if let items = JSONRequestParser.getAsList(data) {
                return [(key, Track.populate(items))]
            }

        case .Album:
            if let items = JSONRequestParser.getAsList(data) {
                return [(key, Album.populate(items))]
            }

        case .Artist:
            if let items = JSONRequestParser.getAsList(data) {
                return [(key, Artist.populate(items))]
            }

        case .Index:
            if let items = JSONRequestParser.getAsList(data) {
                return [(key, ArtistIndex.populate(items))]
            }

        case .Playlist:
            if let items = JSONRequestParser.getAsList(data) {
                return [(key, Playlist.populate(items))]
            }

        case .Genre:
            if let items = self.getAsList(data) {
                return [(key, Genre.populate(items))]
            }

        case .SongsByGenre, .RandomSongs:
            let items = self.getListFromDict(key: .Track, data: data)
            return JSONRequestParser.extract(key: .Track, data: items)
            
        case .Albums:
            let items = self.getListFromDict(key: .Album, data: data)
            return self.extract(key: .Album, data: items)
            
        case .Artists:
            let items = self.getListFromDict(key: .Index, data: data)
            return self.extract(key: .Index, data: items)
            
        case .Playlists:
            let items = self.getListFromDict(key: .Playlist, data: data)
            return self.extract(key: .Playlist, data: items)

        case .Genres:
            let items = self.getListFromDict(key: .Genre, data: data)
            return self.extract(key: .Genre, data: items)

        case .Search, .Starred:
            let dataDict = JSONRequestParser.getAsDict(data)
            return dataDict!.filter{ (k: String, _) in
                Constants.SubSonicAPI.Results(rawValue: k) != nil
            }.map{ (k: String, v: Any?) in
                self.extract(key: Constants.SubSonicAPI.Results(rawValue: k)!, data: v)
            }.flatMap{ $0 }
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
                
            case Constants.SubSonicAPI.Results.Error.rawValue:
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
