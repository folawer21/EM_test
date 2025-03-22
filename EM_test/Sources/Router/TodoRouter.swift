import UIKit

protocol TodoRouterProtocol {
    func routeToTodoPage(id: String, title: String, description: String, date: String, isCompleted: Bool, onClose: @escaping (Todo?) -> Void)
    func routeToCreationTodo(onClose: @escaping (Todo?) -> Void)
}

final class TodoRouter: TodoRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func routeToTodoPage(id: String, title: String, description: String, date: String, isCompleted: Bool, onClose: @escaping (Todo?) -> Void) {
        let todoPage = TodoInfoViewController()
        todoPage.setup(id: id, title: title, description: description, date: date, isCompleted: isCompleted)
        todoPage.setupCloseAction(onClose: onClose)
        viewController?.navigationController?.pushViewController(todoPage, animated: true)
    }
    
    func routeToCreationTodo(onClose: @escaping (Todo?) -> Void) {
        let todoPage = TodoInfoViewController()
        todoPage.setupCloseAction(onClose: onClose)
        viewController?.navigationController?.pushViewController(todoPage, animated: true)
    }
    
}
