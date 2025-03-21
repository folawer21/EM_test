import UIKit

final class TodoInfoViewController: UIViewController {
    
    func setup(title: String, description: String, date: String) {
        titleTextField.text = title
        descriptionTextView.text = description
        dateLabel.text = date
    }
    
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
        navigationController?.navigationBar.tintColor = .yellow
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backTapped))
        navigationItem.backBarButtonItem = backButton
        
  
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = saveButton
    
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveTapped() {
        let title = titleTextField.text ?? ""
        let description = descriptionTextView.textColor == .lightGray ? "" : descriptionTextView.text
        let date = dateLabel.text ?? ""
        
        print("Сохранение: \(title), \(description), \(date)")
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
        if textView.text == "Описание" && textView.textColor == .lightGray {
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
