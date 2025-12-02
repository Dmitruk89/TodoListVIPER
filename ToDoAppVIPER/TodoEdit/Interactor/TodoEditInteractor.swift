//
//  TodoEditInteractor.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

protocol TodoEditInteractorInput: AnyObject {
    func updateTodo(_ todo: AppTodo)
}

protocol TodoEditInteractorOutput: AnyObject {
    func didUpdate(_ todo: AppTodo)
    func didFail(_ error: String)
}

extension TodoEditInteractorOutput {
    func didUpdate(_ todo: AppTodo) { }
}

final class TodoEditInteractor: TodoEditInteractorInput {
    
    weak var output: TodoEditInteractorOutput?
    
    private let coreData: CoreDataServiceProtocol
    
    init(coreData: CoreDataServiceProtocol = CoreDataService.shared) {
        self.coreData = coreData
    }
    
    func updateTodo(_ todo: AppTodo) {
        coreData.updateTodo(todo) { [weak self] result in
            switch result {
            case .success(let updated):
                self?.output?.didUpdate(updated)
            case .failure(let error):
                self?.output?.didFail(error.localizedDescription)
            }
        }
    }
}
