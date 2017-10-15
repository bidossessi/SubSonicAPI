import Foundation

typealias DownloadResult = (_ result: Download?, _ error: Error?) -> Void

protocol SubSonicDownloadProtocol: URLBuilder {
    var client: MediaDownloadClientProtocol { get }
    var downloadQueue: DownloadQueueProtocol { get }
    weak var delegate: SubSonicDownloadDelegate? { get set }

    // MARK: - Download API methods
    func download(song: Song)
    func download(songs: [Song])
    func download(album: Album)
    func download(albums: [Album])
    func download(artist: Artist)
    func download(artists: [Artist])
    func download(genre: Genre)
    func download(genres: [Genre])
    func download(playlist: Playlist)
    func download(playlists: [Playlist])
    
}



