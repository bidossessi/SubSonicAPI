import Foundation

protocol URLBuilderProtocol {
    func url(config: SubSonicConfig,
             endpoint: Constants.SubSonicAPI.Views,
             params: [String: String]) -> URL
    func url(config: SubSonicConfig, urlForMedia id: String) -> URL
    func url(config: SubSonicConfig, urlForCover id: String) -> URL
}

protocol SubSonicProtocol {
    var urlBuilder: URLBuilderProtocol { get }
}
