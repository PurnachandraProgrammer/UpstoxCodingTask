//
//  CryptoCoinEntityTests.swift
//  UpstoxCodingTaskTests
//
//  Created by Purnachandra on 02/11/24.
//

import XCTest
import CoreData
@testable import UpstoxCodingTask

final class CryptoCoinEntityTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var coreDataHelper: CoreDataHelper!
    var cryptoDataService: CryptoDataService!
    
    override func setUp() {
        super.setUp()
        
        // Set up in-memory persistent container for testing
        persistentContainer = NSPersistentContainer(name: "CryptoCoin")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { (description, error) in
            if let error {
                XCTAssertNil(error, "Failed to load in-memory Core Data store: \(error)")
            }
        }
        
        coreDataHelper = CoreDataHelper.shared
        coreDataHelper.persistentContainer = persistentContainer
        
        cryptoDataService = CryptoDataService()
    }
    
    override func tearDown() {
        persistentContainer = nil
        coreDataHelper.deleteAllObjects()
        coreDataHelper = nil
        super.tearDown()
    }
    
    func testFetchCryptoCoinEntity() {
        
        // Create a CryptoCoinEntity
        let cryptoCoin = CryptoCoin(name: "Ethereum", symbol: "ETH", isNew: false, isActive: true, type: .coin)
        
        cryptoDataService.deleteCryptoCoins()
        cryptoDataService.insertCryptoCoinsInLocalStorage(records: [cryptoCoin])
        
        // Fetch CryptoCoinEntity
        //let (result, error) = self.coreDataHelper.fetchManagedObject(managedObject: CryptoCoinEntity.self)
        
        let (result, error) = cryptoDataService.getCryptoCoinsListFromLocalStorage()
        
        XCTAssertNil(error, "Error fetching CryptoCoinEntity: \(error!)")
        XCTAssertEqual(result?.count, 1, "Expected to fetch one entity.")
        XCTAssertEqual(result?.first?.name, "Ethereum", "Fetched entity name does not match.")
    }
    
    
    func testCreateCryptoCoinEntity() {
        let context = coreDataHelper.context
        let cryptoCoin = CryptoCoinEntity(context: context)
        cryptoCoin.name = "Bitcoin"
        cryptoCoin.symbol = "BTC"
        cryptoCoin.isNew = true
        cryptoCoin.isActive = true
        cryptoCoin.type = CryptoType.coin.rawValue
        
        coreDataHelper.saveContext()
        
        XCTAssertNotNil(cryptoCoin.objectID, "Failed to create CryptoCoinEntity.")
        
        let (result, error) = self.coreDataHelper.fetchManagedObject(managedObject: CryptoCoinEntity.self)
        
        XCTAssertNil(error, "Error fetching CryptoCoinEntity: \(error!)")
        XCTAssertEqual(result?.count, 1, "Expected to fetch one entity.")
        XCTAssertEqual(result?.first?.name, "Bitcoin", "Fetched entity name does not match.")
        
    }

    func testConvertToCryptoCoin() {
        let context = coreDataHelper.context
        
        // Create a CryptoCoinEntity
        let cryptoCoinEntity = CryptoCoinEntity(context: context)
        cryptoCoinEntity.name = "Polkadot"
        cryptoCoinEntity.symbol = "DOT"
        cryptoCoinEntity.isNew = true
        cryptoCoinEntity.isActive = true
        cryptoCoinEntity.type = CryptoType.coin.rawValue
        
        let cryptoCoin = cryptoCoinEntity.convertToCryptoCoin()
        
        XCTAssertEqual(cryptoCoin.name, "Polkadot", "Conversion to CryptoCoin failed for name.")
        XCTAssertEqual(cryptoCoin.symbol, "DOT", "Conversion to CryptoCoin failed for symbol.")
        XCTAssertEqual(cryptoCoin.isNew, true, "Conversion to CryptoCoin failed for isNew.")
        XCTAssertEqual(cryptoCoin.isActive, true, "Conversion to CryptoCoin failed for isActive.")
        XCTAssertEqual(cryptoCoin.type.rawValue, "coin", "Conversion to CryptoCoin failed for type.")
    }
    
    func test() {
        
        // Create a CryptoCoinEntity
        cryptoDataService.deleteCryptoCoins()
        
        let (result, error) = cryptoDataService.getCryptoCoinsListFromLocalStorage()
        
        XCTAssertNil(error, "Error fetching CryptoCoinEntity: \(error!)")
        XCTAssertEqual(result?.count, 0, "Expected zero entities.")

    }
}
