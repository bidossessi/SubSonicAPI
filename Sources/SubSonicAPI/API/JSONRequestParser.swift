//
//  JSONRequestParser.swift
//  SubTrack
//
//  Created by Stanislas Sodonon on 9/23/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

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
    
    private func process(dataObject: [String: Any]) {
        // query response object is on top
        // then we need to get the actual results object name.
        // results may contain several models or nested models

        for (apiCall, data) in dataObject {
            switch apiCall {
            case Constants.SubSonicAPI.Results.SongsByGenre,
                 Constants.SubSonicAPI.Results.RandomSongs:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Song] as! [[String: Any]]
                return Track.populate(items)
            case Constants.SubSonicAPI.Results.Albums:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Album] as! [[String: Any]]
                return Album.populate(items)
            case Constants.SubSonicAPI.Results.Artists:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Index] as! [[String: Any]]
                return ArtistIndex.populate(items)
            case Constants.SubSonicAPI.Results.Artist:
                let dataDict = data as! [String: Any]
                return Artist.populate(dataDict)
            case Constants.SubSonicAPI.Results.Playlists:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Playlist] as! [[String: Any]]
                return Playlist.populate(items)
            case Constants.SubSonicAPI.Results.Playlist:
                let dataDict = data as! [String: Any]
                return Playlist.populate(dataDict)
            case Constants.SubSonicAPI.Results.Genres:
                let dataDict = data as! [String: Any]
                let items = dataDict[Constants.SubSonicAPI.Results.Genre] as! [[String: Any]]
                return Genre.populate(items)
            default:
                print(apiCall)
            }
        }
    }

}
