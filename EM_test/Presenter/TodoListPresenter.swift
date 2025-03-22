import Foundation

protocol TodoListPresenterProtocol {
    func getTodosCount() -> Int
    func getTodoViewModel(at index: Int) -> TodoViewModel?
    func didSelectTodo(at index: Int)
    func filterTasks(with key: String)
    func openTodoPage(for index: Int)
    func createTodo()
    
    func loadTodos()
    func deleteTodoByIndex(index: Int)
    func toggleTodo(withId id: String)
}



final class TodoListPresenter: TodoListPresenterProtocol {
    func loadTodos() {
        interactor?.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.todos = todos.reversed()
                self?.updateUI()
            case .failure(let error):
                // Обработка ошибки
                self?.handleError(error)
            }
        }
    }
    
    // Удаление задачи по ID
    func deleteTodoByIndex(index: Int) {
        guard index < todos.count else {
            return
        }
        let id = todos[index].id
        interactor?.deleteTodo(withId: id)
        // Обновление UI после удаления
        loadTodos() // Перезагружаем задачи после удаления
        updateUI()
    }
    
    // Обновление UI (можно будет вызывать на UI слое)
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.updateUI()
        }
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
        router?.routeToTodoPage(id: todo.id, title: todo.title, description: todo.description ?? "", date: todo.date, isCompleted: todo.isCompleted) { [weak self] todo in
            guard let todo = todo else { return }
            self?.interactor?.saveOrUpdateTodo(todo: todo)
            self?.loadTodos()
        }
    }
    
    func createTodo() {
        router?.routeToCreationTodo() { [weak self] todo in
            guard let todo = todo else { return }
            self?.interactor?.saveOrUpdateTodo(todo: todo)
            self?.loadTodos()
        }
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

        let viewModel = todos[index].toViewModel()
        viewModel.toggleAction = { [weak self] in
            guard let id = self?.todos[index].id else {
                print("ASdASDDASD")
                return }
            print("000000",id)
            self?.toggleTodo(withId: id)
        }
        return viewModel
    }
    
    func didSelectTodo(at index: Int) { // TODO: чекнуть надо ли
    }
    
    func filterTasks(with key: String) {
    }
    
    func toggleTodo(withId id: String) {
        print(888888888)
        print(todos)
        print(999999999)
        interactor?.toggleTodoCompletion(withId: id)
        loadTodos()
        print(todos)
    }
    
}
