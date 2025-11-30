//
//  MainInteractorTests.swift
//  ToDoAppVIPERTests
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import XCTest
@testable import ToDoAppVIPER

final class MainInteractorTests: XCTestCase {

    final class MockAPIService: TodoAPIServiceProtocol {
        var shouldReturnError = false
        var fetchCalled = false

        func fetchTodos(completion: @escaping (Result<ApiTodoResponse, NetworkError>) -> Void) {
            fetchCalled = true

            if shouldReturnError {
                completion(.failure(.transportError(NSError(domain: "mock", code: -1))))
            } else {
                let todos = [
                    ApiTodo(id: 1, todo: "Test", completed: false, userId: 100)
                ]
                let response = ApiTodoResponse(todos: todos, total: 1, skip: 0, limit: 10)
                completion(.success(response))
            }
        }
    }

    final class MockCoreDataService: CoreDataServiceProtocol {
        var isEmptyValue = true
        var isEmptyCalled = false
        var fetchTodosCalled = false
        var saveCalled = false

        var todosToReturn: [AppTodo] = []

        func isEmpty(completion: @escaping (Bool) -> Void) {
            isEmptyCalled = true
            completion(isEmptyValue)
        }

        func fetchTodos(completion: @escaping (Result<[AppTodo], Error>) -> Void) {
            fetchTodosCalled = true
            completion(.success(todosToReturn))
        }

        func saveTodosFromAPI(_ apiTodos: [ApiTodo], completion: @escaping (Result<Void, Error>) -> Void) {
            saveCalled = true
            todosToReturn = apiTodos.map { AppTodo(id: $0.id, title: "Задача \($0.id)", description: $0.todo, completed: $0.completed, createdAt: Date()) }
            completion(.success(()))
        }
    }

    final class MockOutput: MainInteractorOutput {
        var loadedTodos: [AppTodo]?
        var loadedError: String?

        func didLoadTodos(_ todos: [AppTodo]) {
            loadedTodos = todos
        }

        func didFailLoadingTodos(_ error: String) {
            loadedError = error
        }
    }
    
    override func setUp() {
        super.setUp()
        AppLaunchUtility.isFirstLaunchOverride = nil
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
    }
    
    func test_loadTodos_onFirstLaunch_callsAPIAndSaves() {
        AppLaunchUtility.isFirstLaunchOverride = true
        
        let apiService = MockAPIService()
        let coreData = MockCoreDataService()

        let interactor = MainInteractor(apiService: apiService, coreData: coreData)
        let output = MockOutput()
        interactor.output = output

        let expectation = XCTestExpectation(description: "Load todos from API on first launch")

        interactor.loadTodos()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(apiService.fetchCalled, "Expected API call on first launch.")
            XCTAssertTrue(coreData.saveCalled, "Expected saving to CoreData.")
            XCTAssertEqual(output.loadedTodos?.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_loadTodos_onSubsequentLaunch_callsCoreDataOnly() {
        AppLaunchUtility.isFirstLaunchOverride = false
        
        let apiService = MockAPIService()
        let coreData = MockCoreDataService()
        
        coreData.todosToReturn = [AppTodo(id: 10, title: "CoreData Task", description: "Task description", completed: false, createdAt: Date())]
        
        let interactor = MainInteractor(apiService: apiService, coreData: coreData)
        let output = MockOutput()
        interactor.output = output
        
        let expectation = XCTestExpectation(description: "Load todos from CoreData on subsequent launch")
        
        interactor.loadTodos()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(apiService.fetchCalled, "API should not be called on subsequent launches.")
            XCTAssertTrue(coreData.fetchTodosCalled, "Expected CoreData fetchTodos call.")
            XCTAssertEqual(output.loadedTodos?.first?.id, 10)
            XCTAssertFalse(coreData.saveCalled, "Saving should not be called.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_loadTodos_APIError_passesErrorToOutput_onFirstLaunch() {
        AppLaunchUtility.isFirstLaunchOverride = true
        
        let apiService = MockAPIService()
        apiService.shouldReturnError = true
        let coreData = MockCoreDataService()

        let interactor = MainInteractor(apiService: apiService, coreData: coreData)
        let output = MockOutput()
        interactor.output = output

        let expectation = XCTestExpectation(description: "Load todos from API with error")

        interactor.loadTodos()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(apiService.fetchCalled)
            XCTAssertNotNil(output.loadedError)
            XCTAssertFalse(coreData.fetchTodosCalled, "CoreData fetch should not be called after API error.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
