import SwiftUI

final class TodoViewModel: ObservableObject {
    
    @Published var isCompleted: Bool
    let title: String
    let description: String?
    let date: String
    init(title: String, isCompleted: Bool, description: String?, date: String) {
        self.title = title
        self.isCompleted = isCompleted
        self.description = description
        self.date = date
    }
    
    func toggleCompletion() {
        isCompleted.toggle()
    }
    
}

extension Todo {
    func toViewModel() -> TodoViewModel {
        TodoViewModel(
            title: self.title,
            isCompleted: self.isCompleted,
            description: self.description,
            date: self.date
        )
    }
}
