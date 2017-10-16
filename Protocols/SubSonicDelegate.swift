import Foundation


protocol SubConfigDelegate: class {
    func config(_ client: SubSonicProtocol) -> SubSonicConfig

}

protocol SubSonicDataDelegate: class,  SubConfigDelegate{
    func sub(_ client: SubSonicDataProtocol,
             endpoint: Constants.SubSonicAPI.Views,
             results: [Constants.SubSonicAPI.Results: [SubItem]]?,
             error: Error?) -> Void
}

protocol SubSonicDownloadDelegate: class, SubConfigDelegate {
    func sub(_ client: SubSonicDownloadProtocol,
             saveMedia download: Download?,
             error: Error?) -> Void
    func queueEmpty(_ client: SubSonicDownloadProtocol) -> Void

}
