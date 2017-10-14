import Foundation

protocol SubSonicDelegate: class {
    func sub(_ client: SubSonicProtocol,
             endpoint: Constants.SubSonicAPI.Views) -> SubSonicConfig
    func sub(_ client: SubSonicProtocol,
             endpoint: Constants.SubSonicAPI.Views,
             results: [Constants.SubSonicAPI.Results: [SubItem]]?,
             error: Error?) -> Void
}
