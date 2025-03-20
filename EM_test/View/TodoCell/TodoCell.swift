import UIKit
import SwiftUI

final class TodoCell: UITableViewCell {
    private var hostingContoller: UIHostingController<TodoView>?
    
    func configure(with viewModel: TodoViewModel) {
        if hostingContoller == nil {
            let todoView = TodoView(viewModel: viewModel)
            let hostingContoller = UIHostingController(rootView: todoView)
            self.hostingContoller = hostingContoller
            contentView.addSubview(hostingContoller.view)
            
            hostingContoller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingContoller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingContoller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingContoller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingContoller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        } else {
            hostingContoller?.rootView = TodoView(viewModel: viewModel)
        }
    }
    
    override func prepareForReuse() {
        hostingContoller = nil
    }
}
