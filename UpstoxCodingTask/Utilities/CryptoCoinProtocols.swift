import Foundation

// Methods for Base protocol
protocol CryptoCoinListBaseService {
    func getCryptoCoinsList() async -> ([CryptoCoin]?,Error?)
}

protocol CryptoLocalStorageService {
    
    func getCryptoCoinsListFromLocalStorage() -> ([CryptoCoin]?,Error?)
    func insertCryptoCoinsInLocalStorage(records:Array<CryptoCoin>,completionHandler: @escaping (_ error:Error?) -> Void)
}

protocol CryptoCoinListApiResourceService : CryptoCoinListBaseService {
    
}

