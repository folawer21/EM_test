import XCTest
@testable import EM_test

class TodoInteractorTests: XCTestCase {
    
    var interactor: TodoInteractor!
    var mockCoreDataService: MockCoreDataService!
    var mockNetworkService: MockNetworkService!
    let context = MockCoreDataStack.context
    
    override func setUp() {
        super.setUp()
        

        mockCoreDataService = MockCoreDataService(context: context)
        mockNetworkService = MockNetworkService()
        interactor = TodoInteractor(networkService: mockNetworkService, coreDataService: mockCoreDataService)
    }
    
    override func tearDown() {
        interactor = nil
        mockCoreDataService = nil
        mockNetworkService = nil
        
        super.tearDown()
    }
    
    func testFetchTodos_withText_shouldReturnSuccess() {
        let todo = Todo(id: "2D0F6278-3CC9-4D8F-95EF-6D56B3B6DFF0", title: "Test Todo", description: nil, date: "01/01/2024", isCompleted:  false)
        let todoCD = TodoEntity(context: context)
        todoCD.id = UUID(uuidString: "2D0F6278-3CC9-4D8F-95EF-6D56B3B6DFF0")
        todoCD.todoTitle = todo.title
        todoCD.todoDescription = todo.description
        todoCD.date = todo.date
        todoCD.isCompleted = todo.isCompleted
        mockCoreDataService.todos = [todoCD]
        
        let expectation = self.expectation(description: "FetchTodos")
        
        interactor.fetchTodos(with: "Test") { result in
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 1)
                XCTAssertEqual(todos.first?.title, "Test Todo")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchTodos_whenCoreDataEmpty_shouldFetchFromNetwork() {
        mockCoreDataService.todos = []
        let todoNetwork = TodoNetwork(id: 1, todo: "Test Todo", completed: true, userId: 123)
        mockNetworkService.fetchTodosResult = .success([todoNetwork])
        
        let expectation = self.expectation(description: "FetchTodos")
        
        interactor.fetchTodos(with: "Test") { result in
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.count, 1)
                XCTAssertEqual(todos.first?.title, "Test Todo")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchTodos_whenNetworkFails_shouldReturnFailure() {
        mockNetworkService.fetchTodosResult = .failure(NSError(domain: "", code: 0, userInfo: nil))
        
        let expectation = self.expectation(description: "FetchTodos")
        
        interactor.fetchTodos(with: "Test") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    func testDeleteTodo_shouldRemoveTodo() {
        let todo = Todo(id: "2D0F6278-3CC9-4D8F-95EF-6D56B3B6DFF0", title: "Todo to Delete", description: nil, date: "01/01/2024", isCompleted: false)
        let todoCD = TodoEntity(context: context)
        todoCD.id = UUID(uuidString: todo.id)
        todoCD.todoTitle = todo.title
        todoCD.todoDescription = todo.description
        todoCD.date = todo.date
        todoCD.isCompleted = todo.isCompleted
        mockCoreDataService.todos = [todoCD]
        
        let expectation = self.expectation(description: "Delete Todo")
        
        interactor.deleteTodo(withId: "2D0F6278-3CC9-4D8F-95EF-6D56B3B6DFF0")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockCoreDataService.todos.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    
    func testToggleTodoCompletion_shouldToggleCompletionStatus() {
        let todo = Todo(id: "2D0F6278-3CC9-4D8F-95EF-6D56B3B6DFF0", title: "Todo", description: nil, date: "01/01/2024", isCompleted: true)
        let todoCD = TodoEntity(context: context)
        todoCD.id = UUID(uuidString: todo.id)!
        todoCD.todoTitle = todo.title
        todoCD.todoDescription = todo.description
        todoCD.date = todo.date
        todoCD.isCompleted = todo.isCompleted
        mockCoreDataService.todos = [todoCD]
        
        interactor.toggleTodoCompletion(withId: "2D0F6278-3CC9-4D8F-95EF-6D56B3B6DFF0")
        
        XCTAssertTrue(mockCoreDataService.todos.first?.isCompleted ?? false)
    }
}
