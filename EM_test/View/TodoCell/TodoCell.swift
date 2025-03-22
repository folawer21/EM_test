import UIKit
import SwiftUI

final class TodoCell: UITableViewCell {
    private var hostingController: UIHostingController<TodoView>?
    
    func configure(with viewModel: TodoViewModel) {
        if hostingController == nil {
            let todoView = TodoView(viewModel: viewModel)
            hostingController = UIHostingController(rootView: todoView)
            guard let hostingController = hostingController else {
                return
            }
            contentView.addSubview(hostingController.view)
            
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        } else {
            hostingController?.rootView = TodoView(viewModel: viewModel)
        }
    }
    
    deinit {
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()
        hostingController = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()
        hostingController = nil
    }
}
