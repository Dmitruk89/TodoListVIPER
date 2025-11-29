//
//  MainInteractorTests.swift
//  ToDoAppVIPERTests
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import XCTest
@testable import ToDoAppVIPER

final class MainInteractorTests: XCTestCase {

    final class MockService: TodoAPIServiceProtocol {

        var shouldReturnError = false
        var fetchCalled = false

        func fetchTodos(completion: @escaping (Result<ApiTodoResponse, NetworkError>) -> Void) {
            fetchCalled = true

            if shouldReturnError {
                completion(.failure(.transportError(NSError(domain: "mock", code: -1))))
            } else {
                let todos = [
                    Todo(id: 1, todo: "Test", completed: false, userId: nil)
                ]
                let response = ApiTodoResponse(
                    todos: todos,
                    total: 1,
                    skip: 0,
                    limit: 10
                )
                completion(.success(response))
            }
        }
    }

    final class MockOutput: MainInteractorOutput {
        var loadedTodos: [Todo]?
        var loadedError: String?

        func didLoadTodos(_ todos: [Todo]) {
            loadedTodos = todos
        }

        func didFailLoadingTodos(_ error: String) {
            loadedError = error
        }
    }

    func test_loadTodos_callsService() {
        let service = MockService()
        let interactor = MainInteractor(service: service)
        let output = MockOutput()
        interactor.output = output

        interactor.loadTodos()

        XCTAssertTrue(service.fetchCalled,
                      "Interactor must call service.fetchTodos()")
    }

    func test_loadTodos_success_passesTodosToOutput() {
        let service = MockService()
        let interactor = MainInteractor(service: service)
        let output = MockOutput()
        interactor.output = output

        interactor.loadTodos()

        XCTAssertEqual(output.loadedTodos?.count, 1,
                       "Interactor must forward todos to Presenter via output.didLoadTodos()")
    }

    func test_loadTodos_failure_passesErrorToOutput() {
        let service = MockService()
        service.shouldReturnError = true

        let interactor = MainInteractor(service: service)
        let output = MockOutput()
        interactor.output = output

        interactor.loadTodos()

        XCTAssertNotNil(output.loadedError,
                        "Interactor must forward errors to Presenter via output.didFailLoadingTodos()")
    }
}
