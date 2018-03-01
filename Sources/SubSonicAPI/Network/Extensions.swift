import Foundation


// MARK: String URLEscaping
extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}

// MARK: Turns a dictionary into a query string
extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}

// MARK: Returns the element at the specified index iff it is within bounds, otherwise nil.
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: returns a filtered array of unique members
func uniq<S: Sequence, E: Hashable>(source: S) -> [E] where E == S.Iterator.Element {
    var seen = [E: Bool]()
    return source.filter { seen.updateValue(true, forKey: $0) == nil }
}


enum NetworkError: Error, Equatable {
    case Query
    case Response(code: Int)
}

func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.Query, .Query):
        return true
    case (.Response(code: let lcode), .Response(code: let rcode)):
        return lcode == rcode
    default:
        return false
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol { }

protocol URLSessionDownloadTaskProtocol {
    func resume()
}
extension URLSessionDownloadTask: URLSessionDownloadTaskProtocol { }


typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func downloadTask(with url: URL) -> URLSessionDownloadTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    func downloadTask(with url: URL) -> URLSessionDownloadTaskProtocol {
        return (downloadTask(with: url) as URLSessionDownloadTask) as URLSessionDownloadTaskProtocol
    }
}

