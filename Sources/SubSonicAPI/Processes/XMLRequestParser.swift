import Foundation

class XMLRequestParser: NSObject, RequestParser {
    
    var currentString, lastTag, requestName: String?
    var processIndex: Int = 0
    var results: [String: [SubItem]] = [
        "artistIndexes": [ArtistIndex](),
        "artists": [Artist](),
        "albums": [Album](),
        "genres": [Genre](),
        "playlists": [Playlist](),
        "tracks": [Track]()
    ]
    var onComplete: ((_ result: [String: [SubItem]]) ->())?

    override init() {
        super.init()
        print("XMLRequestParser started")
    }
    
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
        switch elementName {
        case Constants.SubSonicInfo.apiResponse:
            // Check the response
            do {
                try self.validate(status: attributeDict[Constants.SubSonicInfo.RequestStatusAttr] as String!)
                try self.validate(version: attributeDict[Constants.SubSonicInfo.APIVersionAttr] as String!)
            } catch {
                parser.abortParsing()
                return
            }
            
        case Constants.SubSonicAPI.Results.Track:
            self.results["tracks"]?.append(Track.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Album:
            self.results["albums"]?.append(Album.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Artist:
            self.results["artists"]?.append(Artist.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Playlist:
            self.results["playlists"]?.append(Playlist.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Index:
            self.results["artistIndexes"]?.append(ArtistIndex.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Entry:
            self.results["tracks"]?.append(Track.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Genre:
            self.currentString = ""
            self.results["genres"]?.append(Genre.populate(attributeDict))
        default:
            print(elementName)
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
        if self.processIndex == 1 {
            self.requestName = elementName
        }
        switch elementName {
        case Constants.SubSonicAPI.Results.Index:
            let index = self.results["artistIndexes"]?.last as! ArtistIndex
            index.artists = self.results["artists"] as? [Artist]
            self.results["artists"] = []
        case Constants.SubSonicAPI.Results.Playlist:
            let index = self.results["playlists"]?.last as! Playlist
            index.tracks = self.results["tracks"] as? [Track]
            self.results["tracks"] = []
        case Constants.SubSonicAPI.Results.Genre:
            let genre = self.results["genres"]?.last as! Genre
            genre.name = self.currentString!
        case Constants.SubSonicAPI.Results.Album:
            if self.requestName == elementName {
                let index = self.results["albums"]?.last as! Album
                index.tracks = self.results["tracks"] as? [Track]
                self.results["tracks"] = []
            }
        case Constants.SubSonicAPI.Results.Artist:
            if self.requestName == elementName {
                let index = self.results["artists"]?.last as! Artist
                index.albums = self.results["albums"] as? [Album]
                self.results["albums"] = []
            }
        default:
            break
        }
        self.lastTag = elementName
        self.currentString = nil
    }
    
    // Document end
    func parserDidEndDocument(_ parser: XMLParser) {
        self.onComplete?(self.results)
    }

}

