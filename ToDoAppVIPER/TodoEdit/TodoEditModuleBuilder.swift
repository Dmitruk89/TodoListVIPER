//
//  TodoEditModuleBuilder.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//


import UIKit

final class TodoEditModuleBuilder {
    static func build(with todo: AppTodo) -> UIViewController {
        
        let view = TodoEditViewController()
        let presenter = TodoEditPresenter(todo: todo)
        let interactor = TodoEditInteractor()
        let router = TodoEditRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        
        return view
    }
}
