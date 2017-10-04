//
//  Track.swift
//  SubTrack
//
//  Created by Stanislas Sodonon on 6/5/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

import Foundation


class Track: Hashable {

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
        let id = data["id"] as! NSNumber
        let title = data["title"] as! String
        let path = data["path"] as! String
        let mo = Track(id: id.intValue, title: title, path: path)

        if let track = data["track"] as? NSNumber {
            mo.track = track.intValue
        }
        if let parent = data["parent"] as? NSNumber {
            mo.parent = parent.intValue
        }
        let albumId = data["albumId"] as! NSNumber
        mo.albumId = albumId.intValue
        let artistId = data["artistId"] as! NSNumber
        mo.artistId = artistId.intValue
        let size = data["size"] as! NSNumber
        mo.size = size.intValue
        let bitRate = data["bitRate"] as! NSNumber
        mo.bitRate = bitRate.intValue
        let duration = data["duration"] as! NSNumber
        mo.duration = duration.intValue
        if let year = data["year"] as? NSNumber {
            mo.year = year.intValue
        }
        
        mo.artist = data["artist"] as? String
        mo.album = data["album"] as? String
        mo.genre = data["genre"] as? String
        mo.coverArt = data["coverArt"] as? String
        mo.contentType = data["contentType"] as? String
        mo.suffix = data["suffix"] as? String
        return mo
    }
    
    class func populate(_ array: [[String: Any]]) -> Set<Track> {
        let datas = array.map { Track.populate($0) }
        return Set<Track>(datas)
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return id
    }
    static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id && lhs.path == rhs.path
    }

}


