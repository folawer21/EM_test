import Foundation

protocol TodoInteractorProtocol {
    func fetchTodos(with text: String, completion: @escaping (Result<[Todo], Error>) -> Void)
    func deleteTodo(withId id: String)
    func saveOrUpdateTodo(todo: Todo)
    func toggleTodoCompletion(withId id: String)
}

final class TodoInteractor: TodoInteractorProtocol {
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private let userDefaults = UserDefaults.standard
    private let isFirstLaunchKey = "isFirstLaunch"

    // MARK: - Initializer
    init(networkService: NetworkServiceProtocol = NetworkService(),
         coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    // MARK: - Internal Methods
    
    func saveOrUpdateTodo(todo: Todo) {
        guard let id = UUID(uuidString: todo.id) else { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            if self?.coreDataService.getTodoById(id: id) != nil {
                self?.coreDataService.deleteTodo(withId: todo.id)
            }
            self?.coreDataService.saveTodos([todo])
        }
    }
    
    func fetchTodos(with text: String, completion: @escaping (Result<[Todo], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let isFirstLaunch = self.userDefaults.bool(forKey: self.isFirstLaunchKey)
            
            if !isFirstLaunch {
                let coreDataTodos = self.coreDataService.fetchTodos(containing: text).map { Todo(from: $0) }
                
                if !coreDataTodos.isEmpty {
                    DispatchQueue.main.async {
                        completion(.success(coreDataTodos))
                    }
                    return
                }
            }
            
            self.networkService.fetchTodos { result in
                switch result {
                case .success(let todos):
                    let todosModel = todos.map { Todo(from: $0) }
                    
                    DispatchQueue.global(qos: .background).async {
                        self.coreDataService.saveTodos(todosModel)
                        self.userDefaults.set(false, forKey: self.isFirstLaunchKey)
                        
                        DispatchQueue.main.async {
                            completion(.success(todosModel))
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteTodo(withId id: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.coreDataService.deleteTodo(withId: id)
        }
    }
    
    func toggleTodoCompletion(withId id: String) {
        guard let uuid = UUID(uuidString: id) else {
            print("Invalid UUID string")
            return
        }

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.coreDataService.toggleTodoCompletion(withId: uuid) { success in
                DispatchQueue.main.async {
                    if success {
                        print("Todo updated successfully")
                    } else {
                        print("Failed to update Todo")
                    }
                }
            }
        }
    }
}
