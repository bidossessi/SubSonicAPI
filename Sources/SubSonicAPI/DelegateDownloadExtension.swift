//
// SubSonicProtocol Handler extension
//
//

import Foundation

extension SubSonicDownloadProtocol {
    
    func enqueueSong(config: SubSonicConfig, song: Song) {
        let url = self.url(config: config, urlForMedia: String(song.id))
        client.enqueue(url: url, forItem: song)
    }
    
    func download(song: Song) {
        guard let delegate: SubSonicDownloadDelegate = self.delegate else {
            return
        }
        let config = delegate.config(self)
        enqueueSong(config: config, song: song)
    }

    
    func download(songs: [Song]) {
        guard let delegate: SubSonicDownloadDelegate = self.delegate else {
            return
        }
        let config = delegate.config(self)
        songs.forEach { (song) in
            enqueueSong(config: config, song: song)
        }
    }
    
    func download(album: Album) {}
    func download(albums: [Album]) {}
    func download(artist: Artist) {}
    func download(artists: [Artist]) {}
    func download(genre: Genre) {}
    func download(genres: [Genre]) {}
    func download(playlist: Playlist) {}
    func download(playlists: [Playlist]) {}

}
