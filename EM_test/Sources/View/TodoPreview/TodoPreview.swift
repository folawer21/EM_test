import UIKit

final class TaskPreviewController: UIViewController {
    
    // MARK: - Properties
    private let taskTitle: String
    private let taskDetails: String
    private let taskDate: String
    
    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    private let dateLabel = UILabel()
    
    // MARK: - Initializer
    init(taskTitle: String, taskDetails: String, taskDate: String) {
        self.taskTitle = taskTitle
        self.taskDetails = taskDetails
        self.taskDate = taskDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Preferred Content Size
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 320, height: 106)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .clear
        setupCardView()
        setupLabels()
        setupConstraints()
    }
    
    // MARK: - Setup Card View
    private func setupCardView() {
        cardView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        view.addSubview(cardView)
        view.bringSubviewToFront(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup Labels
    private func setupLabels() {
        setupTitleLabel()
        setupDetailsLabel()
        setupDateLabel()
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(detailsLabel)
        cardView.addSubview(dateLabel)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = taskTitle
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDetailsLabel() {
        detailsLabel.text = taskDetails
        detailsLabel.textColor = .lightGray
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.numberOfLines = 2
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDateLabel() {
        dateLabel.text = taskDate
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Card view constraints
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 320),
            cardView.heightAnchor.constraint(equalToConstant: 106),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Details label constraints
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Date label constraints
            dateLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
}
