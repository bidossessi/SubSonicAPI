import Foundation

struct Playlist: Hashable, SubItem {
    let id: Int
    let name: String
    let songCount, duration: Int?
    let songs: [Song]

    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}


