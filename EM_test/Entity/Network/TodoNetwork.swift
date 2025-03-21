import Foundation

struct TodoNetwork: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TodoResponse: Decodable {
    let todos: [TodoNetwork]
    let total: Int
    let skip: Int
    let limit: Int
}
