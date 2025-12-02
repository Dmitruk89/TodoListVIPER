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
        let router = TodoEditRouter()
        let interactor = TodoEditInteractor()
        let presenter = TodoEditPresenter(todo: todo, interactor: interactor, router: router)
        
        view.presenter = presenter
        presenter.view = view
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}
