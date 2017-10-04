import Foundation


class JSONRequestParser: RequestParser {
    
        
    init() {
        print("JSONRequestParser started")
    }

    func parse(data: Data) {        
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            guard let response = json?[Constants.SubSonicInfo.apiResponse] as? [String: Any] else {
                fatalError("Invalid SubSonic response")
            }
            // Check the response
            try? self.validate(status: response[Constants.SubSonicInfo.RequestStatusAttr] as! String)
            try? self.validate(version: response[Constants.SubSonicInfo.APIVersionAttr] as! String)
            return self.process(response)
        } else {
            fatalError("JSON deserialization failed")
        }
    }
    
    private func process(dataObject: [String: Any]) -> [String: Set] {
        // query response object is on top
        // then we need to get the actual results object name.
        // results may contain several models or nested models
        // But we ALWAYS return Sets
        var results: [String: Set] = [:]
        for (apiCall, data) in dataObject {
            switch apiCall {
            case Constants.SubSonicAPI.Results.SongsByGenre,
                 Constants.SubSonicAPI.Results.RandomSongs:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Track] as! [[String: Any]]
                results[apiCall] = Track.populate(items)
            case Constants.SubSonicAPI.Results.Albums:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Album] as! [[String: Any]]
                results[apiCall] = Album.populate(items)
            case Constants.SubSonicAPI.Results.Artists:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Index] as! [[String: Any]]
                results[apiCall] = ArtistIndex.populate(items)
            case Constants.SubSonicAPI.Results.Artist:
                let dataDict = data as! [String: Any]
                results[apiCall] = Set<Artist>([Artist.populate(dataDict)])
            case Constants.SubSonicAPI.Results.Playlists:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Playlist] as! [[String: Any]]
                results[apiCall] = Playlist.populate(items)
            case Constants.SubSonicAPI.Results.Playlist:
                let dataDict = data as! [String: Any]
                results[apiCall] = Set<Playlist>([Playlist.populate(dataDict)])
            case Constants.SubSonicAPI.Results.Genres:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Genre] as! [[String: Any]]
                results[apiCall] = Genre.populate(items)
            default:
                print(apiCall)
            }
        }
        
        return results
    }

}
