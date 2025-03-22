import SwiftUI

final class TodoViewModel {
    
    let isCompleted: Bool
    let title: String
    let description: String?
    let date: String
    let id: String
    var toggleAction: () -> Void = {}
    
    init(id: String,title: String, isCompleted: Bool, description: String?, date: String) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.description = description
        self.date = date
    }
    
    deinit {
        toggleAction = {}
    }
}

extension Todo {
    func toViewModel() -> TodoViewModel {
        TodoViewModel(
            id: self.id,
            title: self.title,
            isCompleted: self.isCompleted,
            description: self.description,
            date: self.date
        )
    }
}
