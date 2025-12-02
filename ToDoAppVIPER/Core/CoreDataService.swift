//
//  CoreDataService.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 29.11.25.
//

import Foundation
import CoreData
import Combine

public protocol CoreDataServiceProtocol {
    func isEmpty(completion: @escaping (Bool) -> Void)
    func fetchTodos(completion: @escaping (Result<[AppTodo], Error>) -> Void)
    func saveTodosFromAPI(_ apiTodos: [ApiTodo], completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(_ todo: AppTodo, completion: @escaping (Result<AppTodo, Error>) -> Void)
    func deleteTodo(_ todo: AppTodo, completion: @escaping (Result<Void, Error>) -> Void)
    var changesPublisher: AnyPublisher<Void, Never> { get }
}

public final class CoreDataService: CoreDataServiceProtocol {
    public static let shared = CoreDataService(modelName: "CDModel")
    
    private let container: NSPersistentContainer
    
    private var changesSubject = PassthroughSubject<Void, Never>()
    public var changesPublisher: AnyPublisher<Void, Never> {
        changesSubject.eraseToAnyPublisher()
    }
    
    public init(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let err = error {
                fatalError("Unresolved Core Data error: \(err)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: container.viewContext,
            queue: .main
        ) { [weak self] _ in
            self?.changesSubject.send(())
        }
    }
    
    public func isEmpty(completion: @escaping (Bool) -> Void) {
        let ctx = container.viewContext
        ctx.perform {
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.fetchLimit = 1
            do {
                let count = try ctx.count(for: request)
                DispatchQueue.main.async {
                    completion(count == 0)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    public func fetchTodos(completion: @escaping (Result<[AppTodo], Error>) -> Void) {
        let ctx = container.viewContext
        ctx.perform {
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            do {
                let entities = try ctx.fetch(request)
                let todos = entities.map { $0.toAppTodo() }
                DispatchQueue.main.async { completion(.success(todos)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    public func saveTodosFromAPI(_ apiTodos: [ApiTodo], completion: @escaping (Result<Void, Error>) -> Void) {
        container.performBackgroundTask { bgContext in
            do {
                for apiTodo in apiTodos {
                    let fetch: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
                    fetch.predicate = NSPredicate(format: "id == %d", apiTodo.id)
                    fetch.fetchLimit = 1
                    
                    let entity = try bgContext.fetch(fetch).first ?? TodoEntity(context: bgContext)
                    entity.update(from: apiTodo)
                }
                
                if bgContext.hasChanges {
                    try bgContext.save()
                }
                
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    public func updateTodo(_ todo: AppTodo, completion: @escaping (Result<AppTodo, Error>) -> Void) {
        
        container.performBackgroundTask { bgContext in
            let fetch: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", todo.id)
            fetch.fetchLimit = 1

            do {
                guard let entity = try bgContext.fetch(fetch).first else {
                    let err = NSError(domain: "CoreData", code: 404,
                                      userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
                    DispatchQueue.main.async { completion(.failure(err)) }
                    return
                }

                entity.title = todo.title
                entity.desc = todo.description
                entity.completed = todo.completed
                entity.createdAt = todo.createdAt

                try bgContext.save()

                let updated = entity.toAppTodo()

                DispatchQueue.main.async {
                    self.changesSubject.send(())
                    completion(.success(updated))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func deleteTodo(_ todo: AppTodo, completion: @escaping (Result<Void, Error>) -> Void) {
        container.performBackgroundTask { bgContext in
            let fetch: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %d", todo.id)
            fetch.fetchLimit = 1
            
            do {
                guard let entity = try bgContext.fetch(fetch).first else {
                    let err = NSError(domain: "CoreData", code: 404,
                                      userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
                    DispatchQueue.main.async { completion(.failure(err)) }
                    return
                }
                
                bgContext.delete(entity)
                try bgContext.save()
                
                DispatchQueue.main.async {
                    self.changesSubject.send(())
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
