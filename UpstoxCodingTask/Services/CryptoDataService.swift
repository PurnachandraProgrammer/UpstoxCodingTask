//
//  CryptoCoreDataService.swift
//  UpstoxCodingTask
//
//  Created by purnachandra rao obulasetty on 01/12/2024.
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
    
    @discardableResult func insertCryptoCoinsInLocalStorage(records: Array<CryptoCoin>) -> Error? {

        let coreDataHelper = CoreDataHelper.shared
        let context = coreDataHelper.context

        for record in records {

            let cryptoCoin = CryptoCoinEntity(context: context)
            cryptoCoin.name = record.name
            cryptoCoin.symbol = record.symbol
            cryptoCoin.isNew = record.isNew
            cryptoCoin.isActive = record.isActive
            cryptoCoin.type = record.type.rawValue
            
            coreDataHelper.saveContext()
            

        }
        return nil
    }
    
    @discardableResult func deleteCryptoCoins() -> Error? {
        
        // List of multiple objects to delete
        let (objects,_) = CoreDataHelper.shared.fetchManagedObject(managedObject: CryptoCoinEntity.self)

        // Get a reference to a managed object context
        let context = CoreDataHelper.shared.context

        guard let objects = objects else { return NSError(domain: "Objects are nil", code: 500)}
        
        // Delete multiple objects
        for object in objects {
            context.delete(object)
        }

        // Save the deletions to the persistent store
        do {
            try context.save()
        }
        catch {
            return error
        }
        
        return nil
    }
}
