import Foundation

struct Album: Hashable, SubItem {
    
    let id: Int
    let name: String
    let artist, title, genre, coverArt: String?
    let songCount, duration, artistId, year: Int?
    let songs: [Song]
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

}

