//
//  TodoResponse.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

public struct ApiTodoResponse: Codable {
    public let todos: [ApiTodo]
    public let total: Int
    public let skip: Int
    public let limit: Int

    public init(todos: [ApiTodo], total: Int, skip: Int = 0, limit: Int = 0) {
        self.todos = todos
        self.total = total
        self.skip = skip
        self.limit = limit
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.todos = try container.decodeIfPresent([ApiTodo].self, forKey: .todos) ?? []
        self.total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        self.skip = try container.decodeIfPresent(Int.self, forKey: .skip) ?? 0
        self.limit = try container.decodeIfPresent(Int.self, forKey: .limit) ?? 0
    }
}
