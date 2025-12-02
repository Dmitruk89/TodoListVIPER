//
//  TodoEditPresenter.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

protocol TodoEditViewOutput: AnyObject {
    func viewDidLoad()
}

import Foundation

final class TodoEditPresenter: TodoEditViewOutput, TodoEditInteractorOutput {

    weak var view: TodoEditViewInput?
    private let interactor: TodoEditInteractorInput
    private let router: TodoEditRouterInput
    
    private let todo: AppTodo

    init(todo: AppTodo,
         interactor: TodoEditInteractorInput,
         router: TodoEditRouterInput) {
        self.todo = todo
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.display(todo: todo)
    }
}
