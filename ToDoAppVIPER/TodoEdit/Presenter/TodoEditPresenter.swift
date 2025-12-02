//
//  TodoEditPresenter.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

protocol TodoEditViewOutput: AnyObject {
    func viewDidLoad()
    func updateTodo(_ todo: AppTodo)
}

import Foundation

final class TodoEditPresenter: TodoEditViewOutput, TodoEditInteractorOutput {
    
    weak var view: TodoEditViewInput?
    var interactor: TodoEditInteractorInput!
    var router: TodoEditRouterInput!
    
    private let todo: AppTodo
    
    init(todo: AppTodo) {
        self.todo = todo
    }
    
    func viewDidLoad() {
        view?.display(todo: todo)
    }
    
    func updateTodo(_ todo: AppTodo) {
        interactor.updateTodo(todo)
    }
    
    func didFail(_ error: String) {
        print("Update failed: \(error)")
    }
}
