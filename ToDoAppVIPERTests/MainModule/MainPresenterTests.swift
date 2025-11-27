//
//  MainPresenterTests.swift
//  ToDoAppVIPERTests
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import XCTest
@testable import ToDoAppVIPER

final class MainPresenterTests: XCTestCase {

    final class MockView: MainViewProtocol {
        var shownTodos: [Todo]?
        var shownError: String?

        func showTodos(_ todos: [Todo]) {
            shownTodos = todos
        }

        func showError(_ message: String) {
            shownError = message
        }
    }

    final class MockInteractor: MainInteractorProtocol {
        var didCallLoadTodos = false

        func loadTodos() {
            didCallLoadTodos = true
        }
    }

    final class MockRouter: MainRouterProtocol {}

    func test_viewDidLoad_triggersInteractorLoadTodos() {
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()

        let presenter = MainPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        presenter.viewDidLoad()

        XCTAssertTrue(interactor.didCallLoadTodos,
                      "Presenter should call interactor.loadTodos() when the view loads")
    }

    func test_didLoadTodos_callsViewShowTodos() {
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()

        let presenter = MainPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        let todos = [
            Todo(id: 1, todo: "Test1", completed: false, userId: 1),
            Todo(id: 2, todo: "Test2", completed: true, userId: nil)
        ]

        presenter.didLoadTodos(todos)

        XCTAssertEqual(view.shownTodos?.count, 2,
                       "Presenter should forward loaded todos to the view")
    }

    func test_didFailLoadingTodos_callsViewShowError() {
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()

        let presenter = MainPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        let errorMessage = "Network error"

        presenter.didFailLoadingTodos(errorMessage)

        XCTAssertEqual(view.shownError, errorMessage,
                       "Presenter should pass error messages to the view")
    }
}
