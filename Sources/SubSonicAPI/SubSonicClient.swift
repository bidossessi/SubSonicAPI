import Foundation

protocol SubSonicConfig {
    var serverUrl: String { get }
    var username: String { get }
    var password: String { get }
}

typealias QueryResult = (_ result: [Constants.SubSonicAPI.Results: [SubItem]]?, _ error: Error?) -> Void

protocol SubSonicProtocol {
    func randomSongs(config: SubSonicConfig, resultHandler handler: @escaping QueryResult)
}

class DataRequestClient: SubSonicProtocol, URLBuilder {
    let client: HTTPRequestCLientProtocol
    let parser: RequestParser
    private var jsonParser: JSONRequestParser?
    private var XMLParser: XMLRequestParser?
    
    init(client: HTTPRequestCLientProtocol, parser: RequestParser) {
        self.client = client
        self.parser = parser
    }
    
    func query(config: SubSonicConfig,
             endpoint: Constants.SubSonicAPI.Views,
             params: [String: String],
             handler: @escaping QueryResult) {
        let url = self.url(config: config, endpoint: endpoint, params: params)
        
        // MARK: Prepare parser
        self.parser.onComplete = { (results, error) in
            handler(results, error)
        }
        
        // MARK: prepare http
        self.client.onComplete = { (data, error) in
            if let _ = error {
                handler(nil, error)
            } else {
                self.parser.parse(data: data!)
            }
        }
        // MARK: Run it
        self.client.query(url)
    }
    
    func randomSongs(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config,
                   endpoint: .RandomSongs,
                   params: [:],
                   handler: handler)
    }
}
