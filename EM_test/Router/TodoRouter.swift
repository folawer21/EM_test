import UIKit

protocol TodoRouterProtocol {
    func routeToTodoPage(title: String, description: String, date: String)
    func routeToCreationTodo()
}

final class TodoRouter: TodoRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func routeToTodoPage(title: String, description: String, date: String) {
        let todoPage = TodoInfoViewController()
        todoPage.setup(title: title, description: description, date: date)
        viewController?.navigationController?.pushViewController(todoPage, animated: true)
    }
    
    func routeToCreationTodo() {
        let todoPage = TodoInfoViewController()
        viewController?.navigationController?.pushViewController(todoPage, animated: true)
    }
    
}
