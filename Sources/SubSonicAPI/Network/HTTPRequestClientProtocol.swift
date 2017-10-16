import Foundation

protocol HTTPRequestCLientProtocol: class {
    var taskDataMap: [URLSessionTask: Data] { get set }
    var onComplete: ((_ result: Data?, _ error: NetworkError?) ->())? { get set }
    func query(_ url: URL)
}
