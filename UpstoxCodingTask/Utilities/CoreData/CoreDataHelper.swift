import Foundation

import CoreData

final class CoreDataHelper
{

    private init(){}
    static let shared = CoreDataHelper()

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
}
