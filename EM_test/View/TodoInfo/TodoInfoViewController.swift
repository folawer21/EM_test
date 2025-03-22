import UIKit

final class TodoInfoViewController: UIViewController {
    func setup(id: String, title: String, description: String, date: String, isCompleted: Bool) {
        
        self.id = id
        self.todoTitle = title
        self.todoDescription = description
        self.date = date
        self.isCompleted = isCompleted
        
        titleTextField.text = title
        descriptionTextView.text = description
        dateLabel.text = date
    }
    
    func setupCloseAction(onClose: @escaping (Todo?) -> Void) {
        self.onClose = onClose
    }
    
    private var onClose: ((Todo?) -> Void)?
    private var id: String?
    private var todoTitle: String?
    private var todoDescription: String?
    private var date: String?
    private var isCompleted: Bool?
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Заголовок"
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColors.white
        textView.text = "Описание"
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.text = DateFormatterHelper.getCurrentDate()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addSubViews()
        setupConstraints()
        setupView()
        
        descriptionTextView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = UIColors.yellow
        
        // Создаем кастомную кнопку назад с иконкой и текстом
        let backButton = UIButton(type: .system)
        
        // Добавляем стрелку назад и текст
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal) // Стандартная стрелка назад
        backButton.setTitle("Назад", for: .normal)
        backButton.setTitleColor(UIColors.yellow, for: .normal) // Цвет текста
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17) // Настроить шрифт по необходимости
        
        // Добавляем отступы, чтобы текст и иконка не накладывались друг на друга
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        
        // Действие по нажатию
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc private func backTapped() {
        
        navigationController?.popViewController(animated: true)
        if titleTextField.text == todoTitle && descriptionTextView.text == todoDescription  {
            return
        }
        let newId = id ?? UUID().uuidString
        let newTodo = Todo(
            id: newId,
            title: titleTextField.text ?? "",
            description: descriptionTextView.text ?? "",
            date: date ?? DateFormatterHelper.getCurrentDate(),
            isCompleted: isCompleted ?? false
        )
        
        DispatchQueue.global().async { [weak self] in
            self?.onClose?(newTodo)
        }
    }
    
    private func setupView() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubViews() {
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Дата форматтер
final class DateFormatterHelper {
    static func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: Date())
    }
}

// MARK: - Placeholder для UITextView
extension TodoInfoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Добавьте описание" && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = UIColors.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Описание"
            textView.textColor = UIColors.white
        }
    }
}
