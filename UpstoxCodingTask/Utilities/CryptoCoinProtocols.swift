import Foundation

// Methods for Base protocol
protocol CryptoCoinListBaseService {
    func getCryptoCoinsList() async -> ([CryptoCoin]?,Error?)
}

// CryptoCoinListApiResourceService protocol for Apiresource
protocol CryptoCoinListApiResourceService : CryptoCoinListBaseService {

}

