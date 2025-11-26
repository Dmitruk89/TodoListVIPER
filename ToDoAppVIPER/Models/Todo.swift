//
//  Todo.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

import Foundation

public struct Todo: Codable, Identifiable {
    public let id: Int
    public let todo: String
    public let completed: Bool
    public let userId: Int?
}
