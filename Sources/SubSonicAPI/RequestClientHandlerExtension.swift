//
// SubSonicProtocol Handler extension
//
//

import Foundation

extension SubSonicDataProtocol {
    func query(config: SubSonicConfig,
             endpoint: Constants.SubSonicAPI.Views,
             params: [String: String],
             handler: @escaping QueryResult) {
        let url = self.urlBuilder.url(config: config, endpoint: endpoint, params: params)
        
        let parser = self.getParser(from: config)
        // MARK: Prepare parser
        parser.onComplete = { (results, error) in
            handler(results, error)
        }
        
        // MARK: prepare http
        self.client.onComplete = { (data, error) in
            if let _ = error {
                handler(nil, error)
            } else {
                parser.parse(data: data!)
            }
        }
        // MARK: Run it
        self.client.query(url)
    }
    
    func randomSongs(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .RandomSongs, params: [:], handler: handler)
    }
    
    func starred(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Starred, params: [:], handler: handler)
    }
    
    func artists(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Artists, params: [:], handler: handler)
    }
    
    func artist(id: Int, config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Artist, params: ["id": String(id)], handler: handler)
    }
    
    func album(id: Int, config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Album, params: ["id": String(id)], handler: handler)
    }
    
    func randomAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Albums, params: ["type": "random"], handler: handler)
    }
    
    func recentAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Albums, params: ["type": "recent"], handler: handler)
    }
    
    func newestAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Albums, params: ["type": "newest"], handler: handler)
    }
    
    func highestAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Albums, params: ["type": "highest"], handler: handler)
    }
    
    func frequentAlbums(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Albums, params: ["type": "frequent"], handler: handler)
    }
    
    func song(id: Int, config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Song, params: ["id": String(id)], handler: handler)
    }
    
    func genres(config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Genres, params: [:], handler: handler)
    }
    
    func genre(name: String, config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Genre, params: ["genre": name], handler: handler)
    }
    
    func search(query: String, config: SubSonicConfig, resultHandler handler: @escaping QueryResult) {
        self.query(config: config, endpoint: .Search, params: ["query": query], handler: handler)
    }

}
