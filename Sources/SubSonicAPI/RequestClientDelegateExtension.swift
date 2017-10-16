//
// SubSonicProtocol Delegate extension
//
//

import Foundation

extension SubSonicDataProtocol {
    func queryWithDelegate(endpoint: Constants.SubSonicAPI.Views,
             params: [String: String]) {
        guard let delegate: SubSonicDataDelegate = self.delegate else {
            return
        }
        let config = delegate.config(self)
        let url = self.urlBuilder.url(config: config, endpoint: endpoint, params: params)
        let parser = self.getParser(from: config)

        // MARK: Prepare parser
        parser.onComplete = { (results, error) in
            delegate.sub(self, endpoint: endpoint, results: results, error: error)
        }
        
        // MARK: prepare http
        self.client.onComplete = { (data, error) in
            if let _ = error {
                delegate.sub(self, endpoint: endpoint, results: nil, error: error)
            } else {
                parser.parse(data: data!)
            }
        }
        // MARK: Run it
        self.client.query(url)
    }
    
    func randomSongs() {
        self.queryWithDelegate(endpoint: .RandomSongs, params: [:])
    }

    func starred() {
        self.queryWithDelegate(endpoint: .Starred, params: [:])
    }
    
    func artists() {
        self.queryWithDelegate(endpoint: .Artists, params: [:])
    }

    func artist(id: Int) {
        self.queryWithDelegate(endpoint: .Artist, params: ["id": String(id)])
    }
    
    func album(id: Int) {
        self.queryWithDelegate(endpoint: .Artist, params: ["id": String(id)])
    }
    
    func randomAlbums() {
        self.queryWithDelegate(endpoint: .Albums, params: ["type": "random"])
    }
    
    func recentAlbums() {
        self.queryWithDelegate(endpoint: .Albums, params: ["type": "recent"])
    }
    
    func newestAlbums() {
        self.queryWithDelegate(endpoint: .Albums, params: ["type": "newest"])
    }
    
    func highestAlbums() {
        self.queryWithDelegate(endpoint: .Albums, params: ["type": "highest"])
    }
    
    func frequentAlbums() {
        self.queryWithDelegate(endpoint: .Albums, params: ["type": "frequent"])
    }
    
    func song(id: Int) {
        self.queryWithDelegate(endpoint: .Song, params: ["id": String(id)])
    }
    
    func genres() {
        self.queryWithDelegate(endpoint: .Genres, params: [:])
    }
    
    func genre(name: String) {
        self.queryWithDelegate(endpoint: .Genre, params: ["genre": name])
    }
    
    func search(query: String) {
        self.queryWithDelegate(endpoint: .Search, params: ["query": query])
    }
}
