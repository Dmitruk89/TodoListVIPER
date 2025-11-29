//
//  CoreDataService.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 29.11.25.
//

import Foundation
import CoreData

public protocol CoreDataServiceProtocol {
    func isEmpty(completion: @escaping (Bool) -> Void)
    
    func fetchTodos(completion: @escaping (Result<[AppTodo], Error>) -> Void)
    
    func saveTodosFromAPI(_ apiTodos: [ApiTodo], completion: @escaping (Result<Void, Error>) -> Void)
}

public final class CoreDataService: CoreDataServiceProtocol {
    public static let shared = CoreDataService(modelName: "CDModel")
    
    private let container: NSPersistentContainer
    
    public init(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let err = error {
                fatalError("Unresolved Core Data error: \(err)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
}
