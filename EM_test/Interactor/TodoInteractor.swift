import Foundation

protocol TodoInteractorProtocol {
    func fetchTodos(with text: String, completion: @escaping (Result<[Todo], Error>) -> Void)
    func deleteTodo(withId id: String)
    func saveOrUpdateTodo(todo: Todo)
    func toggleTodoCompletion(withId id: String)
}


final class TodoInteractor: TodoInteractorProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    // Используем UserDefaults для проверки первого запуска
    private let userDefaults = UserDefaults.standard
    private let isFirstLaunchKey = "isFirstLaunch"
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    func saveOrUpdateTodo(todo: Todo) {
        guard let id = UUID(uuidString: todo.id) else {
            return
        }
        if coreDataService.getTodoById(id: id) != nil {
            coreDataService.deleteTodo(withId: todo.id) // Удаляем старую запись
        }
        coreDataService.saveTodos([todo]) // Сохраняем новую версию
    }
    
    // Функция для получения всех задач
    func fetchTodos(with text: String, completion: @escaping (Result<[Todo], Error>) -> Void) {
        // Проверяем флаг первого запуска
        
        let isFirstLaunch = userDefaults.bool(forKey: isFirstLaunchKey)
        print(isFirstLaunch)
        // Если это первый запуск, делаем запрос в сеть
        if !isFirstLaunch {
            // Пробуем получить задачи из Core Data
            let coreDataTodos = coreDataService.fetchTodos(containing: text).map { todoEntity in
                Todo(from: todoEntity)
            }
            
            if !coreDataTodos.isEmpty {
                completion(.success(coreDataTodos))
                return
            }
        }
        
        // Если это первый запуск или данные не были получены из Core Data, запрашиваем их через API
        networkService.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                // Сохраняем данные в Core Data после успешного получения из сети
                let todosModel = todos.map { todo in
                    Todo(from: todo)
                }
                self?.coreDataService.saveTodos(todosModel)
                
                // Устанавливаем флаг первого запуска в UserDefaults
                self?.userDefaults.set(false, forKey: self?.isFirstLaunchKey ?? "")
                
                completion(.success(todosModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Функция для удаления задачи
    func deleteTodo(withId id: String) {
        coreDataService.deleteTodo(withId: id)
    }
    
    func toggleTodoCompletion(withId id: String) {
        guard let uuid = UUID(uuidString: id) else {
            print("Invalid UUID string")
            return
        }

        coreDataService.toggleTodoCompletion(withId: uuid) { success in
            if success {
                print("Todo updated successfully")
            } else {
                print("Failed to update Todo")
            }
        }
    }

}

