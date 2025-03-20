import UIKit

final class TodoListFactory {
    public func makeTodoListViewController() -> UINavigationController {
        let presenter = TodoListPresenter()
        let vc = TodoListViewController(presenter: presenter)
        let router = TodoRouter()
        
        router.viewController = vc
        presenter.router = router
        presenter.view = vc
        
        let navVc = UINavigationController(rootViewController: vc)
        
        return navVc
    }
}
