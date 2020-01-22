import Foundation


struct Song: Hashable, SubItem {

    let id: Int
    let title, path: String
    let artist, album, suffix, contentType, genre, coverArt: String?
    let track, parent, albumId, artistId, bitRate, size, duration, year, rating: Int?

    
    
    
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id && lhs.path == rhs.path
    }

}


