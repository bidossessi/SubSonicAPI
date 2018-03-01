//
// SubSonicProtocol Handler extension
//
//

import Foundation

extension SubSonicDownloadProtocol {
    
    func enqueue(songs: [Song]) {
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

        let songSet = songs.map { (s) -> (URL, Song) in
                let url = self.urlBuilder.url(config: config, urlForMedia: String(s.id))
                return (url, s)
        }
        client.enqueue(set: songSet)
    }
    
    func download(song: Song) {
        self.download(songs: [song])
    }

    func download(songs: [Song]) {
        self.enqueue(songs: songs)
    }
    
    func download(album: Album) {
        self.download(albums: [album])
    }
    
    private func preprocess(albums: [Album]) -> [Album] {
        // TODO: If we dong have any songs, we need to fetch the album individually from the server
        return albums
    }
    
    func download(albums: [Album]) {
        let realList = preprocess(albums: albums)
        let songs: [Song] = realList.map { $0.songs }.reduce([], {x, y in x + y})
        self.download(songs: songs)
    }
    
    func download(artist: Artist) {
        self.download(artists: [artist])
    }
    
    private func preprocess(artists: [Artist]) -> [Artist] {
        // TODO: If we dong have any albums, we need to fetch the artists individually from the server
        return artists
    }
    func download(artists: [Artist]) {
        let realList = preprocess(artists: artists)
        let albums: [Album] = realList.map { $0.albums }.reduce([], {x, y in x + y})
        self.download(albums: albums)
    }
    
    func download(playlist: Playlist) {
        self.download(playlists: [playlist])
    }

    private func preprocess(playlists: [Playlist]) -> [Playlist] {
        // TODO: If we dong have any songs, we need to fetch the playlists individually from the server
        return playlists
    }
    func download(playlists: [Playlist]) {
        let realList = preprocess(playlists: playlists)
        let songs: [Song] = realList.map { $0.songs }.reduce([], {x, y in x + y})
        self.enqueue(songs: songs)
    }

    func download(genre: Genre) {
        self.download(genres: [genre])
    }
    func download(genres: [Genre]) {
        // Genres don't have songs.
    }

}
