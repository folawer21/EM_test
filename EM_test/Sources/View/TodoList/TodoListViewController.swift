import UIKit

protocol TodoListViewProtocol: AnyObject {
    func updateUI()
}

final class TodoListViewController: UIViewController, TodoListViewProtocol {
    // MARK: - Properties
    private let presenter: TodoListPresenterProtocol
    
    private let bottomView = UIView()
    private let bottomSafeView = UIView()
    
    private let countLabel = UILabel()
    private let addButton = UIButton()
    
    private let tableView = UITableView()
    
    // MARK: - Initializer
    
    init(presenter: TodoListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadTodos()
        addSubViews()
        setupTableView()
        setupSearchController()
        setupButtomView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - UI Setup
    
    private func addSubViews() {
        bottomView.addSubview(countLabel)
        bottomView.addSubview(addButton)
        
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(bottomSafeView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupButtomView() {
        bottomView.backgroundColor = UIColors.gray
        bottomSafeView.backgroundColor = UIColors.gray
        
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 11, weight: .regular)
        updateCountLabel()
        
        addButton.setImage(UIImages.pencil, for: .normal)
        addButton.tintColor = .yellow
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 49),
            
            bottomSafeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSafeView.topAnchor.constraint(equalTo: bottomView.bottomAnchor),
            bottomSafeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSafeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            countLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - UI Updates
    func updateUI() {
        tableView.reloadData()
        updateCountLabel()
    }
    
    private func updateCountLabel() {
        let count = presenter.getTodosCount()
        countLabel.text = String(format: "%d %@", count, getTaskText(for: count))
    }
    
    @objc private func addTodo() {
        presenter.createTodo()
    }
    
    private func getTaskText(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastDigit == 1 && lastTwoDigits != 11 {
            return "Задача"
        } else if lastDigit >= 2 && lastDigit <= 4 && (lastTwoDigits < 10 || lastTwoDigits >= 20) {
            return "Задачи"
        } else {
            return "Задач"
        }
    }
}

// MARK: - TableView DataSource
extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getTodosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell,
              let vm = presenter.getTodoViewModel(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: vm)
        return cell
    }
}

// MARK: - TableView Delegate
extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.openTodoPage(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            guard let task = self.presenter.getTodoViewModel(at: indexPath.row) else {
                fatalError()
            }
            let preview = TaskPreviewController(taskTitle: task.title, taskDetails: task.description ?? "", taskDate: task.date)
            return preview
        }, actionProvider: { _ in
            
            let editAction = UIAction(title: "Редактировать", image: UIImages.edit?.withTintColor(.white, renderingMode: .alwaysOriginal), handler: { [weak self] _ in
                self?.presenter.openTodoPage(for: indexPath.row)
            })
            
            let shareAction = UIAction(title: "Поделиться", image: UIImages.share?.withTintColor(.white, renderingMode: .alwaysOriginal), handler: { [weak self] _ in
                self?.presentShareSheet()
            })
            
            let deleteAction = UIAction(title: "Удалить", image: UIImages.trash, attributes: .destructive, handler: { [weak self] _ in
                self?.presenter.deleteTodoByIndex(index: indexPath.row)
            })
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        })
    }
    
    private func presentShareSheet() {
        let textToShare = "Поделитесь задачей!"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(activityVC, animated: true)
    }
}

// MARK: - Search Controller
extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            presenter.filterTodo(with: searchText)
        }
    }
}
