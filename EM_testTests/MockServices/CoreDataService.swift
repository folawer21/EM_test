@testable import EM_test
import Foundation

import CoreData

final class MockCoreDataService: CoreDataServiceProtocol {
    private let context: NSManagedObjectContext
    var todos: [TodoEntity] = []

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchTodos(containing text: String) -> [TodoEntity] {
        return todos.filter { $0.todoTitle?.contains(text) == true }
    }
    
    func saveTodos(_ todos: [Todo]) {
        self.todos.append(contentsOf: todos.map {
            let todo = TodoEntity(context: context)
            todo.id = UUID(uuidString: $0.id)
            todo.todoTitle = $0.title
            todo.todoDescription = $0.description
            todo.date = $0.date
            todo.isCompleted = $0.isCompleted
            return todo
        })
        saveContext()
    }

    func deleteTodo(withId id: String) {
        if let todoToDelete = todos.first(where: { $0.id?.uuidString == id }) {
            context.delete(todoToDelete)
            todos.removeAll { $0.id?.uuidString == id }
            saveContext()
        }
    }
    
    func getTodoById(id: UUID) -> TodoEntity? {
        return todos.first { $0.id == id }
    }

    func toggleTodoCompletion(withId id: UUID, completion: @escaping (Bool) -> Void) {
        if let todo = todos.first(where: { $0.id == id }) {
            todo.isCompleted.toggle()
            saveContext()
            completion(true)
        } else {
            completion(false)
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}


