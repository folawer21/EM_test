import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoNetwork], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func fetchTodos(completion: @escaping (Result<[TodoNetwork], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todoResponse.todos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
