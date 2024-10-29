//
//  CryptoCoreDataService.swift
//  UpstoxCodingTask
//
//  Created by purnachandra rao obulasetty on 25/11/2024.
//

import Foundation
import CoreData

final class CryptoDataService : CryptoLocalStorageService {

    func getCryptoCoinsListFromLocalStorage() -> ([CryptoCoin]?,Error?) {
        let result = CoreDataHelper.shared.fetchManagedObject(managedObject: CryptoCoinEntity.self)
        var cryptoCoinsList : Array<CryptoCoin> = []
        
        guard let result = result.0 else {
            return (nil,result.1)
        }
        result.forEach({ coreDataCryptoCoin in
            cryptoCoinsList.append(coreDataCryptoCoin.convertToCryptoCoin())
        })
        return (cryptoCoinsList,nil)
    }
    
    func insertCryptoCoinsInLocalStorage(records: Array<CryptoCoin>, completionHandler: @escaping ((any Error)?) -> Void) {
        
        //debugPrint("CryptoCoreDataService: Insert record operation is starting")
       
        CoreDataHelper.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            
            //Create CDPanet with private context
            records.forEach { cryptoCoin in
                let cryptoCoinEntity = CryptoCoinEntity(context: privateManagedContext)
                cryptoCoinEntity.name = cryptoCoin.name
                cryptoCoinEntity.symbol = cryptoCoin.symbol
                cryptoCoinEntity.isNew = cryptoCoin.isNew
                cryptoCoinEntity.isActive = cryptoCoin.isActive
                cryptoCoinEntity.type = cryptoCoin.type.rawValue
            }
            
            // save the changes.
            if(privateManagedContext.hasChanges){
                do {
                    try privateManagedContext.save()
                    completionHandler(nil)
                }
                catch {
                    completionHandler(error)
                }
            }
        }
    }
}
