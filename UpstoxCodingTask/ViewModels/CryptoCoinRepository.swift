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
        
        // Check for internet connection
        if networkManager.isConnectedToInternet() {
            let cryptoCoinsResult  = await cryptoAPIService.getCryptoCoinsList()
            
            // 1. Get the data from the server.
            // 2. Either you have valid data or may not have valid data from the server.
            // 3. You have the data, if you get successfully data, store the data in core data or replace. (Success)
            // 4. Display the data from core data storage.
            // 5. If you have no data, get the data from 4. (core data), display the last stored data.
            // 6.
            
            if let result = cryptoCoinsResult.0 {
                // delete previous data from core data and then insert data
                _ = self.coreDataService.deleteCryptoCoins()
                _ = self.coreDataService.insertCryptoCoinsInLocalStorage(records: result)
                return (fetchFromCoreData(),nil)
            }
            else {
                return fetchFromCoreDataOrReturnError()
            }
        }
        return fetchFromCoreDataOrReturnError()
        
    }
    
    fileprivate func fetchFromCoreDataOrReturnError() -> ([CryptoCoin]?, (any Error)?) {
        // fetch from core data
        if let cryptoData = fetchFromCoreData() {
            return (cryptoData,nil)
        }
        return (nil,NSError(domain: "Something went wrong", code: 500))
    }
    
    private func fetchFromCoreData() -> [CryptoCoin]? {
        let (cryptoCoinsList,_) = coreDataService.getCryptoCoinsListFromLocalStorage()
        return cryptoCoinsList
    }
    
}
