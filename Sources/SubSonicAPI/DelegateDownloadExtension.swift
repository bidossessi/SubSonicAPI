//
// SubSonicProtocol Handler extension
//
//

import Foundation

extension SubSonicDownloadProtocol {
    
    func enqueue(config: SubSonicConfig, songs: [Song]) {
        let songSet = songs.map { (s) -> (URL, Song) in
                let url = self.urlBuilder.url(config: config, urlForMedia: String(s.id))
                return (url, s)
        }
        client.enqueue(set: songSet)
    }
    
    func download(song: Song) {
        guard let delegate: SubSonicDownloadDelegate = self.delegate else {
            return
        }
        self.client.onComplete = { (data, error) in
            delegate.sub(self, saveMedia: data, error: error)
        }
        self.client.onEmpty = { () in
            delegate.queueEmpty(self)
        }
        let config = delegate.config(self)
        enqueue(config: config, songs: [song])
    }

    
    func download(songs: [Song]) {
        guard let delegate: SubSonicDownloadDelegate = self.delegate else {
            return
        }
        self.client.onComplete = { (data, error) in
            delegate.sub(self, saveMedia: data, error: error)
        }
        self.client.onEmpty = { () in
            delegate.queueEmpty(self)
        }
        let config = delegate.config(self)
        enqueue(config: config, songs: songs)
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
