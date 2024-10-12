import Foundation

// MARK: - WelcomeElement
struct CryptoCoin: Codable {
    let name, symbol: String
    let isNew, isActive: Bool
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}

enum TypeEnum: String, Codable {
    case coin = "coin"
    case token = "token"
}

typealias Welcome = [CryptoCoin]

