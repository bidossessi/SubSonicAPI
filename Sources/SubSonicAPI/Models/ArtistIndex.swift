import Foundation

struct ArtistIndex: Hashable, SubItem {
    let name: String
    let artists: [Artist]
   
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name.hashValue * 5)
    }

    static func == (lhs: ArtistIndex, rhs: ArtistIndex) -> Bool {
        return lhs.name == rhs.name
    }

}


