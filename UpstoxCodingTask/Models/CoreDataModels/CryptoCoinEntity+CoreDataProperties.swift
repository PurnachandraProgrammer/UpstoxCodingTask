//
//  CryptoCoinEntity+CoreDataProperties.swift
//  UpstoxCodingTask
//
//  Created by Purnachandra on 27/10/24.
//
//

import Foundation
import CoreData


extension CryptoCoinEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CryptoCoinEntity> {
        return NSFetchRequest<CryptoCoinEntity>(entityName: "CryptoCoinEntity")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var isNew: Bool
    @NSManaged public var name: String
    @NSManaged public var symbol: String
    @NSManaged public var type: String
    
    func convertToCryptoCoin() -> CryptoCoin {
        return CryptoCoin(name:name,
                          symbol: symbol,
                          isNew:isNew,
                          isActive: isActive,
                          type:CryptoType(rawValue: type)!)
    }
}

extension CryptoCoinEntity : Identifiable {

}
