import Foundation

protocol TodoListPresenterProtocol {
    func getTodosCount() -> Int
    func getTodoViewModel(at index: Int) -> TodoViewModel?
    func openTodoPage(for index: Int)
    func createTodo()
    
    func filterTodo(with text: String)
    func loadTodos()
    func deleteTodoByIndex(index: Int)
    func toggleTodo(withId id: String)
}



final class TodoListPresenter: TodoListPresenterProtocol {
    
    // MARK: - Private Properties
    
    private var todos: [Todo] = []
    private var filteredTodos: [Todo] = []

    // MARK: - Public Methods
    
    func loadTodos() {
        fetch()
    }

    func deleteTodoByIndex(index: Int) {
        guard index < todos.count else {
            return
        }
        let id = todos[index].id
        interactor?.deleteTodo(withId: id)
        loadTodos()
        updateUI()
    }

    func openTodoPage(for index: Int) {
        guard index < filteredTodos.count else {
            return
        }
        
        let todo = filteredTodos[index]
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

    func getTodosCount() -> Int {
        return filteredTodos.count
    }
    
    func getTodoViewModel(at index: Int) -> TodoViewModel? {
        guard index < filteredTodos.count else {
            return nil
        }

        let viewModel = filteredTodos[index].toViewModel()
        viewModel.toggleAction = { [weak self] in
            guard let id = self?.filteredTodos[index].id else {
                return }
            self?.toggleTodo(withId: id)
        }
        return viewModel
    }
    
    func toggleTodo(withId id: String) {
        interactor?.toggleTodoCompletion(withId: id)
        loadTodos()
    }
    
    func filterTodo(with text: String) {
        if text.isEmpty {
            filteredTodos = todos
            view?.updateUI()
        } else {
            filteredTodos = todos.filter { $0.title.lowercased().contains(text.lowercased()) }
            view?.updateUI()
        }
    }

    // MARK: - Private Methods
    
    private func fetch(text: String = "") {
        interactor?.fetchTodos(with: text) { [weak self] result in
            switch result {
            case .success(let todos):
                self?.todos = todos.reversed()
                self?.filteredTodos = todos.reversed()
                self?.updateUI()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.updateUI()
        }
    }

    // MARK: - Dependencies
    weak var view: TodoListViewProtocol?
    var router: TodoRouterProtocol?
    var interactor: TodoInteractorProtocol?
}
