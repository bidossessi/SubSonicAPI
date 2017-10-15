import Foundation

struct Constants {
    struct SubSonicAPI {
        enum Views: String {
            case Ping = "ping"
            case RandomSongs = "getRandomSongs"
            case Search = "search3"
            case Starred = "getStarred2"
            case Artists = "getArtists"
            case Artist = "getArtist"
            case Albums = "getAlbumList2"
            case Album = "getAlbum"
            case Genres = "getGenres"
            case Genre = "getSongsByGenre"
            case Playlists = "getPlaylists"
            case Playlist = "getPlaylist"
            case Song = "getSong"
            case Bookmarks = "getBookmarks"
            case Download = "download"
            case CoverArt = "getCoverArt"
            case Stream = "stream"
            case Star = "star"
            case Unstar = "unstar"
        }
        enum Results: String {
            case RandomSongs = "randomSongs"
            case Search = "searchResult3"
            case Starred = "starred2"
            case Index = "index"
            case Artists = "artists"
            case Artist = "artist"
            case Albums = "albumList2"
            case Album = "album"
            case SongsByGenre = "songsByGenre"
            case Genres = "genres"
            case Genre = "genre"
            case Playlists = "playlists"
            case Playlist = "playlist"
            case Song = "song"
            case Entry = "entry"
            case Bookmarks = "bookmarks"
            case Error = "error"

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
