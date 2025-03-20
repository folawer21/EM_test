
protocol TodoListPresenterProtocol {
    func getTodosCount() -> Int
    func getTodoViewModel(at index: Int) -> TodoViewModel?
    func didSelectTodo(at index: Int)
    func filterTasks(with key: String)
    func openTodoPage(for index: Int)
    func createTodo()
}



final class TodoListPresenter: TodoListPresenterProtocol {
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
    
    private var todos = [
        TodoViewModel(
            title: "Почитать книгу",
            isCompleted: true,
            description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
            date: "09/10/24"
        ),
        TodoViewModel(
            title: "Уборка в квартире",
            isCompleted: false,
            description: "Провести генеральную уборку в квартире",
            date: "02/10/24"
        ),
        TodoViewModel(
            title: "Заняться спортом",
            isCompleted: false,
            description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!",
            date: "02/10/24"
        ),
        TodoViewModel(
            title: "Работа над проектом",
            isCompleted: true,
            description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
            date: "09/10/24"
        ),
        TodoViewModel(
            title: "Вечерний отдых",
            isCompleted: false,
            description: "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку",
            date: "02/10/24"
        ),
        TodoViewModel(
            title: "Зарядка утром",
            isCompleted: false,
            description: "АФЫОАОФЫ афыа фыаф ыаф ыва фыафылаывлджат ывфалд ывфтал фыжва лдытфвалдж ыфвальыфвда лдьжфыва лдывалдыфав ь",
            date: "02/10/24"
        ),
        TodoViewModel(
            title: "Работа над проектом",
            isCompleted: true,
            description: "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
            date: "09/10/24"
        )
    ]
    
    func getTodosCount() -> Int {
        todos.count
    }
    
    func getTodoViewModel(at index: Int) -> TodoViewModel? {
        guard index < todos.count else {
            return nil
        }
        
        return todos[index]
    }
    
    func didSelectTodo(at index: Int) {
    }
    
    func filterTasks(with key: String) {
    }
    
}
