import Foundation

enum RequestFormat: String {
    case Json = "json"
    case Xml = "xml"
}
// MARK: Config
protocol SubSonicConfig {
    var serverUrl: String { get }
    var username: String { get }
    var password: String { get }
    var format: RequestFormat { get }
}



