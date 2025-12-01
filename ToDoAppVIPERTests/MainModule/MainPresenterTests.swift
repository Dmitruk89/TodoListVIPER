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
        var shownTodos: [AppTodo]?
        var shownError: String?

        func showTodos(_ todos: [AppTodo]) {
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
            AppTodo(id: 1, title: "Test1", description: "Desc1", completed: false, createdAt: Date()),
            AppTodo(id: 2, title: "Test2", description: "Desc2", completed: true, createdAt: Date())
        ]

        presenter.didLoadTodos(todos)

        XCTAssertEqual(view.shownTodos?.count, 2,
                       "Presenter should forward loaded todos to the view")
        XCTAssertEqual(view.shownTodos?.first?.id, 1)
        XCTAssertEqual(view.shownTodos?.last?.completed, true)
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
    
    // MARK: - Filtering Tests

    func makePresenterWithLoadedTodos(_ todos: [AppTodo]) -> (MainPresenter, MockView) {
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()

        let presenter = MainPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        presenter.didLoadTodos(todos)
        return (presenter, view)
    }

    func test_filterTodos_byTitle() {
        let todos = [
            AppTodo(id: 1, title: "Buy milk", description: "Groceries", completed: false, createdAt: Date()),
            AppTodo(id: 2, title: "Walk dog", description: "Daily", completed: false, createdAt: Date())
        ]

        let (presenter, view) = makePresenterWithLoadedTodos(todos)

        presenter.filterTodos(with: "milk")

        XCTAssertEqual(view.shownTodos?.count, 1)
        XCTAssertEqual(view.shownTodos?.first?.id, 1)
    }

    func test_filterTodos_byDescription() {
        let todos = [
            AppTodo(id: 1, title: "Task 1", description: "Clean kitchen", completed: false, createdAt: Date()),
            AppTodo(id: 2, title: "Task 2", description: "Wash car", completed: false, createdAt: Date())
        ]

        let (presenter, view) = makePresenterWithLoadedTodos(todos)

        presenter.filterTodos(with: "kitchen")

        XCTAssertEqual(view.shownTodos?.count, 1)
        XCTAssertEqual(view.shownTodos?.first?.id, 1)
    }

    func test_filterTodos_byDateFormattedString() {
        let date = Date()
        let dateString = DateUtility.formatShortDate(date) // используется твой формат

        let todos = [
            AppTodo(id: 1, title: "A", description: "B", completed: false, createdAt: date),
            AppTodo(id: 2, title: "C", description: "D", completed: false, createdAt: date.addingTimeInterval(-86400))
        ]

        let (presenter, view) = makePresenterWithLoadedTodos(todos)

        presenter.filterTodos(with: dateString)

        XCTAssertEqual(view.shownTodos?.count, 1)
        XCTAssertEqual(view.shownTodos?.first?.id, 1)
    }

    func test_filterTodos_emptyQuery_returnsAllTodos() {
        let todos = [
            AppTodo(id: 1, title: "Task 1", description: "Desc1", completed: false, createdAt: Date()),
            AppTodo(id: 2, title: "Task 2", description: "Desc2", completed: false, createdAt: Date())
        ]

        let (presenter, view) = makePresenterWithLoadedTodos(todos)

        presenter.filterTodos(with: "")

        XCTAssertEqual(view.shownTodos?.count, 2)
    }
}
