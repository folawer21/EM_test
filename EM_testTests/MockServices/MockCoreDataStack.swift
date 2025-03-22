import CoreData

class MockCoreDataStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EF_Tests")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType 
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
