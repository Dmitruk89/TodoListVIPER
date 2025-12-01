//
//  MainPresenter.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func filterTodos(with query: String)
}

final class MainPresenter: MainPresenterProtocol {

    weak var view: MainViewProtocol?
    private let interactor: MainInteractorProtocol
    private let router: MainRouterProtocol

    private var allTodos: [AppTodo] = []
    
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
    
    func filterTodos(with query: String) {
        guard !query.isEmpty else {
            view?.showTodos(allTodos)
            return
        }
        
        let lowercasedQuery = query.lowercased()
        let filtered = allTodos.filter { todo in
            let dateString = DateUtility.formatShortDate(todo.createdAt).lowercased()
            return todo.title.lowercased().contains(lowercasedQuery) ||
            (todo.description.lowercased().contains(lowercasedQuery)) ||
                   dateString.contains(lowercasedQuery)
        }
        
        view?.showTodos(filtered)
    }
}

extension MainPresenter: MainInteractorOutput {
    func didLoadTodos(_ todos: [AppTodo]) {
        allTodos = todos
        view?.showTodos(todos)
    }

    func didFailLoadingTodos(_ error: String) {
        view?.showError(error)
    }
}
