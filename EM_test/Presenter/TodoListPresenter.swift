
protocol TodoListPresenterProtocol {
    func getTodosCount() -> Int
    func getTodoViewModel(at index: Int) -> TodoViewModel?
    func didSelectTodo(at index: Int)
    func filterTasks(with key: String)
    func openTodoPage(for index: Int)
    func createTodo()
    
    func loadTodos()
    func deleteTodoById(id: String)
}



final class TodoListPresenter: TodoListPresenterProtocol {
    func loadTodos() {
        interactor?.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.todos = todos
                self?.updateUI()
            case .failure(let error):
                // Обработка ошибки
                self?.handleError(error)
            }
        }
    }
    
    // Удаление задачи по ID
    func deleteTodoById(id: String) {
        interactor?.deleteTodo(withId: id)
        // Обновление UI после удаления
        loadTodos() // Перезагружаем задачи после удаления
        updateUI()
    }
    
    // Обновление UI (можно будет вызывать на UI слое)
    private func updateUI() {
        view?.updateUI()
    }
    
    // Обработка ошибки
    private func handleError(_ error: Error) {
        // Здесь можно показать ошибку на UI
        print("Error loading todos: \(error)")
    }
    
    func openTodoPage(for index: Int) {
        guard index < todos.count else {
            return
        }
        
        let todo = todos[index]
        router?.routeToTodoPage(title: todo.title, description: todo.description ?? "", date: todo.date)
    }
    
    func createTodo() {
        router?.routeToCreationTodo()
    }
    
    
    weak var view: TodoListViewProtocol?
    var router: TodoRouterProtocol?
    var interactor: TodoInteractorProtocol?
    
    private var todos: [Todo] = []
    
    func getTodosCount() -> Int {
        todos.count
    }
    
    func getTodoViewModel(at index: Int) -> TodoViewModel? {
        guard index < todos.count else {
            return nil
        }
        
        return todos[index].toViewModel()
    }
    
    func didSelectTodo(at index: Int) { // TODO: чекнуть надо ли
    }
    
    func filterTasks(with key: String) {
    }
    
}
