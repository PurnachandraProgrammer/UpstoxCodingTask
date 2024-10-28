//
//  CryptoCoinRepository.swift
//  UpstoxCodingTask
//
//  Created by Purnachandra on 25/10/24.
//

import Foundation

protocol CryptoDataRepository {
    func fetchCryptoCoinsData() async -> ([CryptoCoin]?,Error?)
}

class CryptoCoinRepository : CryptoDataRepository {
    
    private let cryptoAPIService: CryptoCoinListApiResourceService!
    private let coreDataService: CryptoLocalStorageService!
    private let networkManager: NetworkManager!
    
    init(apiService: CryptoCoinListApiResourceService, coreDataService: CryptoLocalStorageService, networkManager: NetworkManager) {
        self.cryptoAPIService = apiService
        self.coreDataService = coreDataService
        self.networkManager = networkManager
    }
    
    func fetchCryptoCoinsData() async -> ([CryptoCoin]?,Error?) {
        
        if networkManager.isConnectedToInternet() {
            let cryptoCoinsResult  = await cryptoAPIService.getCryptoCoinsList()
            if let result = cryptoCoinsResult.0 {
                coreDataService.insertCryptoCoinsInLocalStorage(records: result) { error in
                    if let error {
                        // TODO : Handle error
                    }
                }
                return cryptoCoinsResult
            }
        }
        else {
            return (fetchFromCoreData(),nil)
        }
        return (nil,NSError(domain: "Something went wrong", code: 500))
    }
    
    private func fetchFromCoreData() -> [CryptoCoin]? {
        let (cryptoCoinsList,_) = coreDataService.getCryptoCoinsListFromLocalStorage()
        return cryptoCoinsList
    }
    
}
