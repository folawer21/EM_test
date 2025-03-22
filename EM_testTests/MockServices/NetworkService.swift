@testable import EM_test

final class MockNetworkService: NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[EM_test.TodoNetwork], any Error>) -> Void) {
        completion(fetchTodosResult)
    }
    
    var fetchTodosResult: Result<[EM_test.TodoNetwork], Error>!
}
