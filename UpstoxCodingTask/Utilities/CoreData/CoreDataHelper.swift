import Foundation

import CoreData

final class CoreDataHelper
{

    private init(){}
    static let shared = CoreDataHelper()

    // Additional initializer for in-memory store
    init(inMemory: Bool = false) {
        if inMemory {
            persistentContainer = NSPersistentContainer(name: "CryptoCoin")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
            persistentContainer.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unresolved error \(error)")
                }
            }
        }
    }

    // MARK: - Core Data stack
    // Get and set the persistentContainer object
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptoCoin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // view context
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> ([T]?,Error?)
    {
        do {
            guard let result = try CoreDataHelper.shared.context.fetch(managedObject.fetchRequest()) as? [T] else { return (nil,NSError(domain: "Data fetch error", code: 500) )
            }
            return (result,nil)

        } catch let error {
            return (nil,error)
        }
    }
    
    @discardableResult func deleteAllObjects() -> Error? {
        
        // List of multiple objects to delete
        let (objects,_) = self.fetchManagedObject(managedObject: CryptoCoinEntity.self)

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



