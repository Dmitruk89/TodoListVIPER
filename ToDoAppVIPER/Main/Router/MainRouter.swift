//
//  MainRouter.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import UIKit

protocol MainRouterProtocol {
    func openTodoEdit(_ todo: AppTodo)
}

final class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?
    
    func openTodoEdit(_ todo: AppTodo) {
        let vc = TodoEditModuleBuilder.build(with: todo)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
