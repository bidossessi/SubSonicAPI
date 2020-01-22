import Foundation

struct Genre: Hashable, SubItem {
    let name: String
    let songCount, albumCount: Int?
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue * 13)
    }

    static func ==(lhs: Genre, rhs: Genre) -> Bool {
        return lhs.name == rhs.name
    }
}


