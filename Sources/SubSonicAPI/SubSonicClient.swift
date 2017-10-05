import Foundation

protocol SubSonicClient {}

protocol SubSonicConfig {
    var serverUrl: String { get }
    var username: String { get }
    var password: String { get }
}
