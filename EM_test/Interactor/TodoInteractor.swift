import Foundation

protocol TodoInteractorProtocol {
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
    func deleteTodo(withId id: String)
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
    
    // Функция для получения всех задач
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        // Проверяем флаг первого запуска
        
        let isFirstLaunch = userDefaults.bool(forKey: isFirstLaunchKey)
        print(isFirstLaunch)
        // Если это первый запуск, делаем запрос в сеть
        if !isFirstLaunch {
            // Пробуем получить задачи из Core Data
            let coreDataTodos = coreDataService.fetchTodos().map { todoEntity in
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
}

