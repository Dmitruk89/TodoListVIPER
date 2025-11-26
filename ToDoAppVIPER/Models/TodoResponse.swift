//
//  TodoResponse.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

public struct TodoResponse: Codable {
    public let todos: [Todo]
    public let total: Int
    public let skip: Int
    public let limit: Int
}
