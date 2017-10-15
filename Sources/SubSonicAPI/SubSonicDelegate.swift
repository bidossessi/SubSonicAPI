import Foundation


protocol SubConfigDelegate: class {
    func config(_ client: URLBuilder) -> SubSonicConfig

}

protocol SubSonicDelegate: class,  SubConfigDelegate{
    func sub(_ client: SubSonicProtocol,
             endpoint: Constants.SubSonicAPI.Views,
             results: [Constants.SubSonicAPI.Results: [SubItem]]?,
             error: Error?) -> Void
}

protocol SubSonicDownloadDelegate: class, SubConfigDelegate {
    func sub(_ client: SubSonicDownloadProtocol,
             saveMedia download: Download?,
             error: Error?) -> Void
}
