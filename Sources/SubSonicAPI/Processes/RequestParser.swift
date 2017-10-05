import Foundation

protocol RequestParser: class {
    func validate(version: String) throws
    func validate(status: String) throws
    func parse(data: Data)
    var onComplete: ((_ result: [String: [SubItem]]) ->())? { get set }
}

extension RequestParser {
    
    func validate(version: String) throws {
        let apiVersion = NSString(string: Constants.SubSonicInfo.apiVersion)
        let options = NSString.CompareOptions.numeric
        let r = apiVersion.compare(version, options: options)
        if r == ComparisonResult.orderedDescending {
            fatalError("Api too old: \(version); minimum required: \(Constants.SubSonicInfo.apiVersion)")
        }
    }
    
    func validate(status: String) throws {
        if status != Constants.SubSonicInfo.RequestStatusOK {
            fatalError("Subsonic server rejected the request")
        }
    }
}
