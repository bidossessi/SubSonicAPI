import Foundation

class XMLRequestParser: NSObject, RequestParser {
    
    var currentString, lastTag, requestName: String?
    var processIndex: Int = 0
    var currentError: ParsingError?
    var results: [String: [SubItem]] = [
        "artistIndexes": [ArtistIndex](),
        "artists": [Artist](),
        "albums": [Album](),
        "genres": [Genre](),
        "playlists": [Playlist](),
        "tracks": [Track]()
    ]
    var onComplete: ((_ result: [String: [SubItem]]?, _ error: ParsingError?) ->())?
    
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
                try self.validate(version: attributeDict[Constants.SubSonicInfo.APIVersionAttr] as String!)
            } catch {
                self.currentError = error as? ParsingError
                parser.abortParsing()
            }
        
        case Constants.SubSonicAPI.Results.Error:
            let errorCode = Int(attributeDict["code"]!)!
            let errorMsg = attributeDict["message"]!
            self.currentError = ParsingError.Status(code: errorCode, message: errorMsg)
            parser.abortParsing()

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
        if parser.parserError == nil {
            self.onComplete?(self.results, nil)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        if self.currentError != nil {
            self.onComplete?(nil, self.currentError)
        } else {
            self.onComplete?(nil, ParsingError.Serialization)
        }
    }
}

