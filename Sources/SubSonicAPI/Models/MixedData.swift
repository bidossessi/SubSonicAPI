//
//  MixedData.swift
//  SubSonicAPI
//
//  Created by Stanislas Sodonon on 10/4/17.
//

import Foundation

class MixedData: SubItem {
    var tracks: [Track]?
    var artists: [Artist]?
    var albums: [Album]?

    class func populate(_ data: [String: Any]) -> MixedData {
        let mo = MixedData()
        // MARK: Albums
        if let albums = data[Constants.SubSonicAPI.Results.Album] as? [[String: Any]] {
            mo.albums = Album.populate(albums)
        } else if let albums = data[Constants.SubSonicAPI.Results.Album] as? [String: Any] {
            // force an array
            mo.albums = [Album.populate(albums)]
        }
        // MARK: Artists
        if let artists = data[Constants.SubSonicAPI.Results.Artist] as? [[String: Any]] {
            mo.artists = Artist.populate(artists)
        } else if let artists = data[Constants.SubSonicAPI.Results.Artist] as? [String: Any] {
            // force a set
            mo.artists = [Artist.populate(artists)]
        }
        // MARK: Tracks
        if let tracks = data[Constants.SubSonicAPI.Results.Track] as? [[String: Any]] {
            mo.tracks = Track.populate(tracks)
        } else if let tracks = data[Constants.SubSonicAPI.Results.Track] as? [String: Any] {
            // force a set
            mo.tracks = [Track.populate(tracks)]
        }
        return mo
    }
}
