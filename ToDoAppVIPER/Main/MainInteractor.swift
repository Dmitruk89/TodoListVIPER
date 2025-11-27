//
//  MainInteractor.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

protocol MainInteractorProtocol {
    func loadTodos()
}

protocol MainInteractorOutput: AnyObject {
    func didLoadTodos(_ todos: [Todo])
    func didFailLoadingTodos(_ error: String)
}

final class MainInteractor: MainInteractorProtocol {

    weak var output: MainInteractorOutput?
    private let service: TodoAPIServiceProtocol

    init(service: TodoAPIServiceProtocol) {
        self.service = service
    }

    func loadTodos() {
        service.fetchTodos { [weak self] result in
            switch result {
            case .success(let response):
                self?.output?.didLoadTodos(response.todos)
            case .failure(let error):
                self?.output?.didFailLoadingTodos(error.localizedDescription)
            }
        }
    }
}
