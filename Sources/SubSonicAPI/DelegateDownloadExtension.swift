//
// SubSonicProtocol Handler extension
//
//

import Foundation

extension SubSonicDownloadProtocol {
    
    func makeSet(config: SubSonicConfig, song: Song) -> (URL, Song) {
        let url = self.url(config: config, urlForMedia: String(song.id))
        return (url, song)
    }
    
    func download(song: Song) {
        guard let delegate: SubSonicDownloadDelegate = self.delegate else {
            return
        }
        let config = delegate.config(self)
        let songTuple = makeSet(config: config, song: song)
        client.enqueue(set: [songTuple])
    }

    
    func download(songs: [Song]) {
        guard let delegate: SubSonicDownloadDelegate = self.delegate else {
            return
        }
        let config = delegate.config(self)
        let songSet = songs.map { (s) -> (URL, Song) in
            makeSet(config: config, song: s)
        }
        client.enqueue(set: songSet)
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
