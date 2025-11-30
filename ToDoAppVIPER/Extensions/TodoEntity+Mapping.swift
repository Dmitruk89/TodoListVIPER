//
//  TodoEntity+Mapping.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 29.11.25.
//

import Foundation
import CoreData

extension TodoEntity {
    func toAppTodo() -> AppTodo {
        return AppTodo(
            id: Int(self.id),
            title: self.title ?? "Задача \(self.id)",
            description: self.desc ?? "",
            completed: self.completed,
            createdAt: self.createdAt ?? Date()
        )
    }
    
    func update(from apiTodo: ApiTodo) {
        self.id = Int64(apiTodo.id)
        self.title = "Задача \(apiTodo.id). \(apiTodo.todo)"
        self.desc = apiTodo.todo
        self.completed = apiTodo.completed
        
        if self.createdAt == nil {
            self.createdAt = Date()
        }
    }
}
