import Foundation

struct Constants {
    struct SubSonicAPI {
        struct Views {
            static let Ping = "ping"
            static let RandomSongs = "getRandomSongs"
            static let Search = "search3"
            static let Starred = "getStarred2"
            static let Artists = "getArtists"
            static let Artist = "getArtist"
            static let Albums = "getAlbumList2"
            static let Album = "getAlbum"
            static let Genres = "getGenres"
            static let Genre = "getSongsByGenre"
            static let Playlists = "getPlaylists"
            static let Playlist = "getPlaylist"
            static let Track = "getSong"
            static let Bookmarks = "getBookmarks"
            static let Download = "download"
            static let Stream = "stream"
            static let Star = "star"
            static let Unstar = "unstar"
        }
        struct Results {
            static let RandomSongs = "randomSongs"
            static let Search = "searchResult3"
            static let Starred = "starred2"
            static let Index = "index"
            static let Artists = "artists"
            static let Artist = "artist"
            static let Albums = "albumList2"
            static let Album = "album"
            static let SongsByGenre = "songsByGenre"
            static let Genres = "genres"
            static let Genre = "genre"
            static let Playlists = "playlists"
            static let Playlist = "playlist"
            static let Track = "song"
            static let Entry = "entry"
            static let Bookmarks = "bookmarks"

        }
    }
    struct SubSonicInfo {
        static let apiResponse = "subsonic-response"
        static let apiVersion = "1.11.0"
        static let apiName = "SubSonicAPI"
        static let apiFormat = "json"
        static let APIVersionAttr = "version"
        static let RequestStatusAttr = "status"
        static let RequestStatusOK = "ok"
        static let RequestStatusFailed = "failed"
    }
}
