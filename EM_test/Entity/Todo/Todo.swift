import Foundation

struct Todo {
    let id: String
    let title: String
    let description: String?
    let date: String
    let isCompleted: Bool
    
    init(from networkModel: TodoNetwork) {
         self.id = String(networkModel.id)
         self.title = networkModel.todo
         self.description = ""
         self.isCompleted = networkModel.completed
         self.date = Todo.getCurrentDate()
     }
    
    init(from databaseModel: TodoEntity) {
        self.id = databaseModel.id?.uuidString ?? UUID().uuidString
        self.title = databaseModel.todoTitle ?? ""
        self.description = databaseModel.todoDescription
        self.isCompleted = databaseModel.isCompleted
        self.date = Todo.getCurrentDate()
    }
    
    init(id: String, title: String, description: String, date: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
    }
     
     private static func getCurrentDate() -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/yy"
         return dateFormatter.string(from: Date())
     }
}

