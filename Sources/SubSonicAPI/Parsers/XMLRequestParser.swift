import Foundation

class XMLRequestParser: NSObject, RequestParser {
    var onComplete: ((Result<[Constants.SubSonicAPI.Results : [SubItem]], ParsingError>) -> ())?
    
    
    var currentString, lastTag, requestName: String?
    var processIndex: Int = 0
    var currentError: ParsingError?
    var results: [Constants.SubSonicAPI.Results: [SubItem]] = [
        .Index: [ArtistIndex](),
        .Artist: [Artist](),
        .Album: [Album](),
        .Genre: [Genre](),
        .Playlist: [Playlist](),
        .Song: [Song]()
    ]
    
    func parse(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
}

extension XMLRequestParser: XMLParserDelegate {
    // Document start
    func parserDidStartDocument(_ parser: XMLParser) {
        print("started document")
    }
    
    //tag Attributes
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {

        if self.processIndex == 0 && elementName != Constants.SubSonicInfo.apiResponse {
            self.currentError = ParsingError.Envelop
            parser.abortParsing()
        }

        if self.processIndex == 1 {
            self.requestName = elementName
        }

        switch elementName {
        case Constants.SubSonicInfo.apiResponse:
            do {
                try self.validate(version: attributeDict[Constants.SubSonicInfo.APIVersionAttr]!)
            } catch {
                self.currentError = error as? ParsingError
                parser.abortParsing()
            }
        
        case Constants.SubSonicAPI.Results.Error.rawValue:
            let errorCode = Int(attributeDict["code"]!)!
            let errorMsg = attributeDict["message"]!
            self.currentError = ParsingError.Status(code: errorCode, message: errorMsg)
            parser.abortParsing()
        case Constants.SubSonicAPI.Results.Song.rawValue:
            self.results[.Song]?.append(XMLRequestParser.populate(song: attributeDict))
        case Constants.SubSonicAPI.Results.Album.rawValue:
            self.results[.Album]?.append(XMLRequestParser.populate(album: attributeDict))
        case Constants.SubSonicAPI.Results.Artist.rawValue:
            self.results[.Artist]?.append(XMLRequestParser.populate(artist: attributeDict))
        case Constants.SubSonicAPI.Results.Playlist.rawValue:
            self.results[.Playlist]?.append(XMLRequestParser.populate(playlist: attributeDict))
        case Constants.SubSonicAPI.Results.Index.rawValue:
            self.results[.Index]?.append(XMLRequestParser.populate(artistIndex: attributeDict))
        case Constants.SubSonicAPI.Results.Entry.rawValue:
            self.results[.Song]?.append(XMLRequestParser.populate(song: attributeDict))
        case Constants.SubSonicAPI.Results.Genre.rawValue:
            self.currentString = ""
            self.results[.Genre]?.append(XMLRequestParser.populate(genre: attributeDict))
        default:
            print("idx: \(self.processIndex), \(elementName)")
        }
        self.processIndex += 1
    }
    
    // tag content
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString? += string
    }
    
    // tag end
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        switch elementName {
        case Constants.SubSonicAPI.Results.Index.rawValue:
            let artists = self.results[.Artist] as? [Artist] ?? []
            let indices = self.results[.Index] as! [ArtistIndex]
            let lastIndex = self.results[.Index]?.last as! ArtistIndex
            let newIndex = ArtistIndex(name: lastIndex.name, artists: artists)
            self.results[.Index] = indices.map { (i) in
                i == lastIndex ? newIndex : i
            }
            self.results[.Artist] = []
        case Constants.SubSonicAPI.Results.Playlist.rawValue:
            let songs = self.results[.Song] as? [Song] ?? []
            let playlists = self.results[.Playlist] as! [Playlist]
            let lastPlaylist = self.results[.Playlist]?.last as! Playlist
            let newPlaylist = Playlist(id: lastPlaylist.id, name: lastPlaylist.name, songCount: lastPlaylist.songCount, duration: lastPlaylist.duration, songs: songs)
            self.results[.Playlist] = playlists.map { (i) in
                i == lastPlaylist ? newPlaylist : i
            }
            self.results[.Song] = []
        case Constants.SubSonicAPI.Results.Genre.rawValue:
            let lastGenre = self.results[.Genre]?.last as! Genre
            let newGenre = Genre(name: self.currentString!, songCount: lastGenre.songCount, albumCount: lastGenre.albumCount)
            let genres = self.results[.Genre] as! [Genre]
            self.results[.Genre] = genres.map { (i) in
                i == lastGenre ? newGenre : i
            }
        case Constants.SubSonicAPI.Results.Album.rawValue:
            if self.requestName == elementName {
                let songs = self.results[.Song] as? [Song] ?? []
                let lastAlbum = self.results[.Album]?.last as! Album
                let albums = self.results[.Album] as! [Album]
                let newAlbum = Album(id: lastAlbum.id, name: lastAlbum.name, artist: lastAlbum.artist, title: lastAlbum.title, genre: lastAlbum.genre, coverArt: lastAlbum.coverArt, songCount: lastAlbum.songCount, duration: lastAlbum.duration, artistId: lastAlbum.artistId, year: lastAlbum.year, songs: songs)
                self.results[.Album] = albums.map { (i) in
                    i == lastAlbum ? newAlbum : i
                }
                self.results[.Song] = []
            }
        case Constants.SubSonicAPI.Results.Artist.rawValue:
            if self.requestName == elementName {
                let albums = self.results[.Album] as? [Album] ?? []
                let lastArtist = self.results[.Artist]?.last as! Artist
                let artists = self.results[.Artist] as! [Artist]
                let newArtist = Artist(id: lastArtist.id, name: lastArtist.name, coverArt: lastArtist.coverArt, albumCount: lastArtist.albumCount, albums: albums)
                self.results[.Artist] = artists.map { (i) in
                    i == lastArtist ? newArtist : i
                }
                self.results[.Album] = []
            }
        default:
            break
        }
        self.lastTag = elementName
        self.currentString = nil
    }
    
    // Document end
    func parserDidEndDocument(_ parser: XMLParser) {
        if parser.parserError == nil {
            self.onComplete?(.success(self.results))
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        if self.currentError != nil {
            self.onComplete?(.failure(self.currentError!))
        } else {
            self.onComplete?(.failure(ParsingError.Serialization))
        }
    }
}

