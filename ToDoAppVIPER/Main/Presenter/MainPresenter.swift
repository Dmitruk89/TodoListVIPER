//
//  MainPresenter.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class MainPresenter: MainPresenterProtocol {

    weak var view: MainViewProtocol?
    private let interactor: MainInteractorProtocol
    private let router: MainRouterProtocol

    init(
        view: MainViewProtocol,
        interactor: MainInteractorProtocol,
        router: MainRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.loadTodos()
    }
}

extension MainPresenter: MainInteractorOutput {
    func didLoadTodos(_ todos: [AppTodo]) {
        view?.showTodos(todos)
    }

    func didFailLoadingTodos(_ error: String) {
        view?.showError(error)
    }
}
