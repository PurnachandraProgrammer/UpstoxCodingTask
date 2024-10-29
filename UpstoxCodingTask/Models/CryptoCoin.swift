import Foundation

struct CryptoCoin: Codable {
    let name, symbol: String
    let isNew, isActive: Bool
    let type: CryptoType

    init(name: String, symbol: String, isNew: Bool, isActive: Bool, type: CryptoType) {
        self.name = name
        self.symbol = symbol
        self.isNew = isNew
        self.isActive = isActive
        self.type = type
    }
    
    init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
        self.isNew = false
        self.isActive = false
        self.type = CryptoType.coin
    }
    
    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
}

enum CryptoType: String, Codable {
    case coin = "coin"
    case token = "token"
}
