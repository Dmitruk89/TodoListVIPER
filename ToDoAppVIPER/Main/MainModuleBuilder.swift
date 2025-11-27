//
//  MainModuleBuilder.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import UIKit

final class MainModuleBuilder {

    static func build() -> UIViewController {
        let view = MainViewController()
        let router = MainRouter()
        let interactor = MainInteractor(service: TodoAPIService())
        let presenter = MainPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view

        return view
    }
}
