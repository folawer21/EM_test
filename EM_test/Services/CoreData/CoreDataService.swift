import CoreData
import UIKit // TODO: УБРАТЬ ОТСЮДА
import Foundation

protocol CoreDataServiceProtocol {
    func fetchTodos() -> [TodoEntity]
    func saveTodos(_ todos: [Todo])
    func deleteTodo(withId id: String)
}

final class CoreDataService: CoreDataServiceProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        self.persistentContainer = container
    }
    
    // Извлекаем todos из Core Data
    func fetchTodos() -> [TodoEntity] {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        do {
            let todos = try persistentContainer.viewContext.fetch(fetchRequest)
            return todos
        } catch {
            print("Error fetching todos from Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    // Сохраняем todos в Core Data
    func saveTodos(_ todos: [Todo]) {
        let context = persistentContainer.viewContext
        
        // Для каждой задачи создаем объект TodoEntity
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
    
    // Удаляем задачу из Core Data по ID
    func deleteTodo(withId id: String) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let todos = try persistentContainer.viewContext.fetch(fetchRequest)
            if let todoToDelete = todos.first {
                persistentContainer.viewContext.delete(todoToDelete)
                try persistentContainer.viewContext.save()
                print("Todo with ID \(id) deleted successfully.")
            } else {
                print("Todo with ID \(id) not found.")
            }
        } catch {
            print("Error deleting todo from Core Data: \(error.localizedDescription)")
        }
    }
}
