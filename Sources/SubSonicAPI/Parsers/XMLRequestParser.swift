import Foundation

class XMLRequestParser: NSObject, RequestParser {
    
    var currentString, lastTag, requestName: String?
    var processIndex: Int = 0
    var currentError: ParsingError?
    var results: [Constants.SubSonicAPI.Results: [SubItem]] = [
        .Index: [ArtistIndex](),
        .Artist: [Artist](),
        .Album: [Album](),
        .Genre: [Genre](),
        .Playlist: [Playlist](),
        .Track: [Track]()
    ]
    var onComplete: ((_ result: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: ParsingError?) ->())?

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
        
        case Constants.SubSonicAPI.Results.Error.rawValue:
            let errorCode = Int(attributeDict["code"]!)!
            let errorMsg = attributeDict["message"]!
            self.currentError = ParsingError.Status(code: errorCode, message: errorMsg)
            parser.abortParsing()
        case Constants.SubSonicAPI.Results.Track.rawValue:
            self.results[.Track]?.append(Track.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Album.rawValue:
            self.results[.Album]?.append(Album.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Artist.rawValue:
            self.results[.Artist]?.append(Artist.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Playlist.rawValue:
            self.results[.Playlist]?.append(Playlist.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Index.rawValue:
            self.results[.Index]?.append(ArtistIndex.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Entry.rawValue:
            self.results[.Track]?.append(Track.populate(attributeDict))
        case Constants.SubSonicAPI.Results.Genre.rawValue:
            self.currentString = ""
            self.results[.Genre]?.append(Genre.populate(attributeDict))
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
            let index = self.results[.Index]?.last as! ArtistIndex
            index.artists = self.results[.Artist] as? [Artist]
            self.results[.Artist] = []
        case Constants.SubSonicAPI.Results.Playlist.rawValue:
            let index = self.results[.Playlist]?.last as! Playlist
            index.tracks = self.results[.Track] as? [Track]
            self.results[.Track] = []
        case Constants.SubSonicAPI.Results.Genre.rawValue:
            let genre = self.results[.Genre]?.last as! Genre
            genre.name = self.currentString!
        case Constants.SubSonicAPI.Results.Album.rawValue:
            if self.requestName == elementName {
                let index = self.results[.Album]?.last as! Album
                index.tracks = self.results[.Track] as? [Track]
                self.results[.Track] = []
            }
        case Constants.SubSonicAPI.Results.Artist.rawValue:
            if self.requestName == elementName {
                let index = self.results[.Artist]?.last as! Artist
                index.albums = self.results[.Album] as? [Album]
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

