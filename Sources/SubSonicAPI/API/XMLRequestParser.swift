//
//  XMLRequestParser.swift
//  SubTrack
//
//  Created by Stanislas Sodonon on 9/23/17.
//  Copyright © 2017 Stanislas Sodonon. All rights reserved.
//

//import Foundation
//import CoreData

//class XMLRequestParser: ParserMaestro {
//
//    init() {
//        print("XMLRequestParser started")
//    }
//    func parse(data: Data) throws -> [String: Any] {
//        return [:]
//    }
//    func process(dataObject: [String: Any], context: NSManagedObjectContext) {}
//}
//
//    func parse(requestData data: Data) {
//        if self.container == nil {
//            fatalError("No persistent container defined")
//        }
//        
//        self.container.performBackgroundTask() { (context) in
//            self.context = context
//            // Do the work
//            let parser = XMLParser(data: data)
//            parser.delegate = self
//            parser.parse()
//            // Save changes
//            do {
//                try context.save()
//            } catch {
//                fatalError("Failure to save context: \(error)")
//            }
//        }
//
//    }
//}
//
//extension XMLRequestParser: XMLParserDelegate {
//    // Document start
//    func parserDidStartDocument(_ parser: XMLParser) {
//        print("started document")
//    }
//    
//    //tag Attributes
//    func parser(_ parser: XMLParser,
//                didStartElement elementName: String,
//                namespaceURI: String?,
//                qualifiedName qName: String?,
//                attributes attributeDict: [String : String] = [:]) {
//        switch elementName {
//        case "subsonic-response":
//            // Check the response
//            do {
//                try subsonicValidate(status: attributeDict[Constants.SubSonicInfo.RequestStatusAttr] as! String)
//                try subsonicValidate(version: attributeDict[Constants.SubSonicInfo.APIVersionAttr] as! String)
//            } catch {
//                parser.abortParsing()
//                return
//            }
//        case "song":
//            self.createObject(track: attributeDict)
//        case "album":
//            self.createObject(album: attributeDict)
//        case "artist":
//            self.createObject(artist: attributeDict)
//        case "playlist":
//            self.createObject(playlist: attributeDict)
//        case "index":
//            self.createObject(index: attributeDict)
//        case "entry":
//            self.createObject(entry: attributeDict)
//        case "genre":
//            self.currentString = ""
//            self.createObject(genre: attributeDict)
//        default:
//            print(elementName)
//        }
//        self.processIndex += 1
//    }
//    
//    // tag content
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        
//        self.currentString? += string
//    }
//    
//    // tag end
//    func parser(_ parser: XMLParser,
//                didEndElement elementName: String,
//                namespaceURI: String?,
//                qualifiedName qName: String?) {
//        
//        switch elementName {
//        case "index":
//            let index = self.artistIndexes.last!
//            index.artists = self.artists
//            self.artists = []
//        case "genre":
//            let genre = self.genres.last!
//            genre.title = self.currentString!
//        default:
//            break
//        }
//        self.lastTag = elementName
//        self.currentString = nil
//    }
//    
//    // Document end
//    func parserDidEndDocument(_ parser: XMLParser) {}
//
//}

