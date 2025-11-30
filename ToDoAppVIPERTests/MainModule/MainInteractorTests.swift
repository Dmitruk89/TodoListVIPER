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

    func test_loadTodos_fromAPI_whenCoreDataEmpty() {
        let apiService = MockAPIService()
        let coreData = MockCoreDataService()
        coreData.isEmptyValue = true

        let interactor = MainInteractor(apiService: apiService, coreData: coreData)
        let output = MockOutput()
        interactor.output = output

        let expectation = XCTestExpectation(description: "Load todos from API")
        interactor.loadTodos()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(apiService.fetchCalled)
            XCTAssertTrue(coreData.saveCalled)
            XCTAssertEqual(output.loadedTodos?.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_loadTodos_fromCoreData_whenNotEmpty() {
        let apiService = MockAPIService()
        let coreData = MockCoreDataService()
        coreData.isEmptyValue = false
        coreData.todosToReturn = [AppTodo(id: 10, title: "CoreData Task", description: "", completed: false, createdAt: Date())]

        let interactor = MainInteractor(apiService: apiService, coreData: coreData)
        let output = MockOutput()
        interactor.output = output

        let expectation = XCTestExpectation(description: "Load todos from CoreData")
        interactor.loadTodos()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertFalse(apiService.fetchCalled)
            XCTAssertTrue(coreData.fetchTodosCalled)
            XCTAssertEqual(output.loadedTodos?.first?.id, 10)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_loadTodos_APIError_passesErrorToOutput() {
        let apiService = MockAPIService()
        apiService.shouldReturnError = true
        let coreData = MockCoreDataService()
        coreData.isEmptyValue = true

        let interactor = MainInteractor(apiService: apiService, coreData: coreData)
        let output = MockOutput()
        interactor.output = output

        let expectation = XCTestExpectation(description: "Load todos from API with error")
        interactor.loadTodos()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(output.loadedError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
