import Foundation

enum ParsingError: Error, Equatable {
    case Serialization
    case Envelop
    case Version(found: String, minimum: String)
    case Status(code: Int, message: String)
}

func ==(lhs: ParsingError, rhs: ParsingError) -> Bool {
    switch (lhs, rhs) {
    case (.Serialization, .Serialization):
        return true
    case (.Envelop, .Envelop):
        return true
    case (.Version, .Version):
        return true
    case (.Status(code: let lcode, message: _), .Status(code: let rcode, message: _)):
        return lcode == rcode
    default:
        return false
    }
}


protocol RequestParser: class {
    func validate(version: String) throws
    func parse(data: Data)
    var onComplete: ((_ result: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: ParsingError?) ->())? { get set }
}

extension RequestParser {
    
    func validate(version: String) throws {
        let apiVersion = NSString(string: Constants.SubSonicInfo.apiVersion)
        let options = NSString.CompareOptions.numeric
        let r = apiVersion.compare(version, options: options)
        if r == ComparisonResult.orderedDescending {
            throw ParsingError.Version(found: version, minimum: Constants.SubSonicInfo.apiVersion)
        }
    }
    
    static func getAsList(_ value: Any?) -> [[String: Any]]? {
        if let result = value as? [String: Any] {
            return [result]
        } else if let result = value as? [[String: Any]] {
            return result
        }
        return nil
    }
    
    static func getAsDict(_ value: Any?) -> [String: Any]? {
        if let result = value as? [String: Any] {
            return result
        }
        return nil
    }

    static func getListFromDict(key: Constants.SubSonicAPI.Results, data: Any?) -> [[String: Any]]? {
        if let dataDict = getAsDict(data) {
            return dataDict[key.rawValue] as? [[String: Any]]
        }
        return nil
    }
}
