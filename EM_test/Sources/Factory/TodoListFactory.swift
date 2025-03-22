import UIKit

final class TodoListFactory {
    public func makeTodoListViewController() -> UINavigationController {
        let presenter = TodoListPresenter()
        let vc = TodoListViewController(presenter: presenter)
        let router = TodoRouter()
        let interactor = TodoInteractor()
        router.viewController = vc
        presenter.router = router
        presenter.view = vc
        presenter.interactor = interactor
        
        let navVc = UINavigationController(rootViewController: vc)
        
        return navVc
    }
}
