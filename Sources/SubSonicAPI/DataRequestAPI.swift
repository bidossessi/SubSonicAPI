import Foundation

// MARK: Implementation
class DataRequestAPI: SubSonicProtocol {
    
    
    let client: HTTPRequestCLientProtocol
    weak var delegate: SubSonicDelegate?
    
    init(client: HTTPRequestCLientProtocol) {
        self.client = client
    }
}

