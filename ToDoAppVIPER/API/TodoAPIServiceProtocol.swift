//
//  TodoAPIServiceProtocol.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

import Foundation

public protocol TodoAPIServiceProtocol {
    func fetchTodos(completion: @escaping (Result<ApiTodoResponse, NetworkError>) -> Void)
}
