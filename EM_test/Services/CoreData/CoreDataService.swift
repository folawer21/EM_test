import CoreData
import UIKit
import Foundation

protocol CoreDataServiceProtocol {
    func fetchTodos(containing text: String) -> [TodoEntity]
    func saveTodos(_ todos: [Todo])
    func deleteTodo(withId id: String)
    func getTodoById(id: UUID) -> TodoEntity?
    func toggleTodoCompletion(withId id: UUID, completion: @escaping (Bool) -> Void)
}

final class CoreDataService: CoreDataServiceProtocol {
    
    // MARK: - Private Properties
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Initializer
    init(container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.persistentContainer = container
    }
    
    // MARK: - CoreData Operations
    func getTodoById(id: UUID) -> TodoEntity? {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching todo by ID: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchTodos(containing text: String) -> [TodoEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        
        if !text.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "todoTitle CONTAINS[cd] %@", text)
        }
        
        do {
            let todoEntities = try context.fetch(fetchRequest)
            return todoEntities
        } catch {
            print("Error fetching todos: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveTodos(_ todos: [Todo]) {
        let context = persistentContainer.viewContext
        
        for todo in todos {
            let todoEntity = TodoEntity(context: context)
            todoEntity.id = UUID(uuidString: todo.id) ?? UUID()
            todoEntity.isCompleted = todo.isCompleted
            todoEntity.todoTitle = todo.title
            todoEntity.todoDescription = todo.description
            todoEntity.date = todo.date
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving todos to Core Data: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(withId id: String) {
        guard let uuid = UUID(uuidString: id) else {
            print("Invalid UUID string")
            return
        }
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let todos = try context.fetch(fetchRequest)
            if let todoToDelete = todos.first {
                context.delete(todoToDelete)
                try context.save()
                print("Todo with ID \(id) deleted successfully.")
            } else {
                print("Todo with ID \(id) not found.")
            }
        } catch {
            print("Error deleting todo from Core Data: \(error.localizedDescription)")
        }
    }
    
    func toggleTodoCompletion(withId id: UUID, completion: @escaping (Bool) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let todoEntity = results.first {
                todoEntity.isCompleted.toggle()
                try context.save()
                
                print("Todo updated: \(todoEntity.todoTitle ?? "nil") - isCompleted: \(todoEntity.isCompleted)")
                completion(true)
            } else {
                print("Todo with ID \(id) not found")
                completion(false)
            }
        } catch {
            print("Error toggling completion: \(error.localizedDescription)")
            completion(false)
        }
    }
}
