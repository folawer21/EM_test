import Foundation

protocol TodoInteractorProtocol {
    func fetchTodos(with text: String, completion: @escaping (Result<[Todo], Error>) -> Void)
    func deleteTodo(withId id: String, completion: @escaping () -> Void)
    func saveOrUpdateTodo(todo: Todo, completion: @escaping () -> Void)
    func toggleTodoCompletion(withId id: String, completion: @escaping () -> Void)
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
    
    func saveOrUpdateTodo(todo: Todo, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            if let _ = self.coreDataService.getTodoById(id: UUID(uuidString: todo.id)!) {
                self.coreDataService.deleteTodo(withId: todo.id)
            }
            self.coreDataService.saveTodos([todo])
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func fetchTodos(with text: String, completion: @escaping (Result<[Todo], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let isFirstLaunch = self.userDefaults.bool(forKey: self.isFirstLaunchKey)
            
            let coreDataTodos = self.coreDataService.fetchTodos(containing: text).map { Todo(from: $0) }
            if !coreDataTodos.isEmpty || !isFirstLaunch {
                DispatchQueue.main.async { completion(.success(coreDataTodos)) }
                return
            }
            
            self.networkService.fetchTodos { result in
                switch result {
                case .success(let todos):
                    let todosModel = todos.map { Todo(from: $0) }
                    self.coreDataService.saveTodos(todosModel)
                    self.userDefaults.set(false, forKey: self.isFirstLaunchKey)
                    DispatchQueue.main.async { completion(.success(todosModel)) }
                case .failure(let error):
                    DispatchQueue.main.async { completion(.failure(error)) }
                }
            }
        }
    }
    
    func deleteTodo(withId id: String, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.coreDataService.deleteTodo(withId: id)
            DispatchQueue.main.async { completion() }
        }
    }
    
    func toggleTodoCompletion(withId id: String, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.coreDataService.toggleTodoCompletion(withId: UUID(uuidString: id)!) { success in
                DispatchQueue.main.async { completion() }
            }
        }
    }
}
