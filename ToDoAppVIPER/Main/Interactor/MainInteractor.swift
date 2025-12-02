//
//  MainInteractor.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 27.11.25.
//

import Foundation
import Combine

protocol MainInteractorProtocol {
    func loadTodos()
    func createTodo()
    func updateTodo(_ todo: AppTodo)
    func deleteTodo(_ todo: AppTodo)
}

protocol MainInteractorOutput: AnyObject {
    func didLoadTodos(_ todos: [AppTodo])
    func didFailLoadingTodos(_ error: String)
    
    func didUpdateTodo(_ todo: AppTodo)
    func didFailUpdatingTodo(_ error: String)
    
    func didDeleteTodo(_ todo: AppTodo)
    func didFailDeletingTodo(_ error: String)
    
    func didCreateTodo(_ todo: AppTodo)
    func didFailCreatingTodo(_ error: String)
}

final class MainInteractor: MainInteractorProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var output: MainInteractorOutput?
    
    private let apiService: TodoAPIServiceProtocol
    private let coreData: CoreDataServiceProtocol
    
    init(apiService: TodoAPIServiceProtocol,
         coreData: CoreDataServiceProtocol = CoreDataService.shared) {
        self.apiService = apiService
        self.coreData = coreData
        
        subscribeToCoreDataUpdates()
    }
    
    func loadTodos() {
        if AppLaunchUtility.isFirstLaunch() {
            self.loadFromAPIAndSaveToCoreData()
        } else {
            self.loadFromCoreData()
        }
    }
    
    private func subscribeToCoreDataUpdates() {
        coreData.changesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadFromCoreData()
            }
            .store(in: &cancellables)
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
    
    func createTodo() {
        coreData.createNewTodo { [weak self] result in
            switch result {
            case .success(let newTodo):
                self?.output?.didCreateTodo(newTodo)
            case .failure(let error):
                self?.output?.didFailCreatingTodo(error.localizedDescription)
            }
        }
    }
    
    func updateTodo(_ todo: AppTodo) {
        coreData.updateTodo(todo) { [weak self] result in
            switch result {
            case .success(let updated):
                self?.output?.didUpdateTodo(updated)
            case .failure(let error):
                self?.output?.didFailUpdatingTodo(error.localizedDescription)
            }
        }
    }
    
    func deleteTodo(_ todo: AppTodo) {
        coreData.deleteTodo(todo) { [weak self] result in
            switch result {
            case .success():
                self?.output?.didDeleteTodo(todo)
            case .failure(let error):
                self?.output?.didFailDeletingTodo(error.localizedDescription)
            }
        }
    }
}
