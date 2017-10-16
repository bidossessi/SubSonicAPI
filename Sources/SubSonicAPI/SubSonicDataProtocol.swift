import Foundation

typealias QueryResult = (_ result: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) -> Void

// MARK: - Protocol
protocol SubSonicDataProtocol: SubSonicProtocol {
    var client: HTTPRequestCLientProtocol { get }
    weak var delegate: SubSonicDataDelegate? { get set }
    func getParser(from config: SubSonicConfig) -> RequestParser
    
    // MARK: - Query API Methods
    func randomSongs()
    func randomSongs(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
    
    func starred()
    func starred(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
    
    func artists()
    func artists(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func artist(id: Int)
    func artist(id: Int, config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func album(id: Int)
    func album(id: Int, config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func randomAlbums()
    func randomAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
    
    func recentAlbums()
    func recentAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func newestAlbums()
    func newestAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
    
    func highestAlbums()
    func highestAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
    
    func frequentAlbums()
    func frequentAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
    
    func song(id: Int)
    func song(id: Int, config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func genres()
    func genres(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func genre(name: String)
    func genre(name: String, config: SubSonicConfig, resultHandler handler: @escaping QueryResult)

    func search(query: String)
    func search(query: String, config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
}

// MARK: - implement getParser
extension SubSonicDataProtocol {
    func getParser(from config: SubSonicConfig) -> RequestParser {
        if config.format == .Json {
            return JSONRequestParser()
        } else {
            return XMLRequestParser()
        }
    }
}
