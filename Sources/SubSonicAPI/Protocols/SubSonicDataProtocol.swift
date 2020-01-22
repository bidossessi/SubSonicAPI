import Foundation

protocol SubSonicDataProtocol {
    
    func randomSongs()
    
    func starred()
    
    func artists()

    func artist(id: Int)

    func album(id: Int)

    func randomAlbums()
    
    func recentAlbums()

    func newestAlbums()
    
    func highestAlbums()
    
    func frequentAlbums()
    
    func song(id: Int)

    func genres()

    func genre(name: String)

    func search(query: String)
}
