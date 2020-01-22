import Foundation

struct Artist: Hashable, SubItem {
    let id: Int
    let name: String
    let coverArt: String?
    let albumCount: Int?
    let albums: [Album]

    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

}
