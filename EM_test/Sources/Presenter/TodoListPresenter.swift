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
    
    // MARK: - Internal Methods
    
    func loadTodos() { fetch() }

    func deleteTodoByIndex(index: Int) {
        guard index < filteredTodos.count else { return }
        let id = filteredTodos[index].id
        interactor?.deleteTodo(withId: id) { [weak self] in
            self?.fetch()
        }
    }

    func openTodoPage(for index: Int) {
        guard index < filteredTodos.count else { return }
        let todo = filteredTodos[index]
        router?.routeToTodoPage(id: todo.id, title: todo.title, description: todo.description ?? "", date: todo.date, isCompleted: todo.isCompleted) { [weak self] todo in
            guard let todo = todo else { return }
            self?.interactor?.saveOrUpdateTodo(todo: todo) { self?.fetch() }
        }
    }

    func createTodo() {
        router?.routeToCreationTodo() { [weak self] todo in
            guard let todo = todo else { return }
            self?.interactor?.saveOrUpdateTodo(todo: todo) { self?.fetch() }
        }
    }

    func getTodosCount() -> Int { filteredTodos.count }

    func getTodoViewModel(at index: Int) -> TodoViewModel? {
        guard index < filteredTodos.count else { return nil }
        let viewModel = filteredTodos[index].toViewModel()
        viewModel.toggleAction = { [weak self] in
            self?.toggleTodo(withId: viewModel.id)
        }
        return viewModel
    }

    func toggleTodo(withId id: String) {
        interactor?.toggleTodoCompletion(withId: id) { [weak self] in
            if let index = self?.filteredTodos.firstIndex(where: { $0.id == id }) {
                self?.filteredTodos[index].isCompleted.toggle()
                self?.updateUI()
            }
        }
    }

    func filterTodo(with text: String) {
        filteredTodos = text.isEmpty ? todos : todos.filter { $0.title.lowercased().contains(text.lowercased()) }
        updateUI()
    }

    //MARK: Private Methods
    
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
    
    // MARK: Dependencies
    
    weak var view: TodoListViewProtocol?
    var router: TodoRouterProtocol?
    var interactor: TodoInteractorProtocol?
}
