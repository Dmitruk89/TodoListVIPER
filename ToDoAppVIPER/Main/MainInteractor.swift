//
//  MainInteractor.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import Foundation

protocol MainInteractorProtocol {
    func loadTodos()
}

protocol MainInteractorOutput: AnyObject {
    func didLoadTodos(_ todos: [AppTodo])
    func didFailLoadingTodos(_ error: String)
}

final class MainInteractor: MainInteractorProtocol {
    
    weak var output: MainInteractorOutput?
    
    private let apiService: TodoAPIServiceProtocol
    private let coreData: CoreDataServiceProtocol
    
    init(apiService: TodoAPIServiceProtocol,
         coreData: CoreDataServiceProtocol = CoreDataService.shared) {
        self.apiService = apiService
        self.coreData = coreData
    }
    
    func loadTodos() {
        if AppLaunchUtility.isFirstLaunch() {
            self.loadFromAPIAndSaveToCoreData()
        } else {
            self.loadFromCoreData()
        }
    }
    
    private func loadFromCoreData() {
        coreData.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.output?.didLoadTodos(todos)
            case .failure(let error):
                self?.output?.didFailLoadingTodos(error.localizedDescription)
            }
        }
    }
    
    private func loadFromAPIAndSaveToCoreData() {
        apiService.fetchTodos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.coreData.saveTodosFromAPI(response.todos) { saveResult in
                    switch saveResult {
                    case .success:
                        self.loadFromCoreData()
                    case .failure(let error):
                        self.output?.didFailLoadingTodos(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                self.output?.didFailLoadingTodos(error.localizedDescription)
            }
        }
    }
}
