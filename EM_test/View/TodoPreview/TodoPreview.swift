import UIKit

final class TaskPreviewController: UIViewController {
    private let taskTitle: String
    private let taskDetails: String
    private let taskDate: String
    
    init(taskTitle: String, taskDetails: String, taskDate: String) {
        self.taskTitle = taskTitle
        self.taskDetails = taskDetails
        self.taskDate = taskDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 320, height: 106)
        }
        set { super.preferredContentSize = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear

        // Размытый фон
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)

        // Карточка задачи
        let cardView = UIView()
        cardView.backgroundColor = UIColor(white: 0.1, alpha: 1)
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = taskTitle
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let detailsLabel = UILabel()
        detailsLabel.text = taskDetails
        detailsLabel.textColor = .lightGray
        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.numberOfLines = 2
        
        let dateLabel = UILabel()
        dateLabel.text = taskDate
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(detailsLabel)
        cardView.addSubview(dateLabel)
        view.addSubview(cardView)
        view.bringSubviewToFront(cardView)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 320),
            cardView.heightAnchor.constraint(equalToConstant: 106),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
}
