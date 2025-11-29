//
//  Todo.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

import Foundation

public struct ApiTodo: Codable, Identifiable {
    public let id: Int
    public let todo: String
    public let completed: Bool
    public let userId: Int?
}

public struct AppTodo: Identifiable {
    public let id: Int
    public let title: String
    public let description: String
    public let completed: Bool
    public let createdAt: Date
}
