//
//  TodoAPIService.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 26.11.25.
//

import Foundation

public final class TodoAPIService: TodoAPIServiceProtocol {
    private let baseURLString: String
    private let session: URLSessionProtocol
    
    public init(baseURLString: String = API.baseURL, session: URLSessionProtocol = URLSession.shared) {
        self.baseURLString = baseURLString
        self.session = session
    }
    
    public func fetchTodos(completion: @escaping (Result<TodoResponse, NetworkError>) -> Void) {
        guard let url = URL(string: API.baseURL + API.Endpoints.todos) else {
            DispatchQueue.main.async { completion(.failure(.badURL)) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let dataTask = self.session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(.transportError(error)))
                        return
                    }
                    
                    if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                        completion(.failure(.badResponse(statusCode: http.statusCode)))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.unknown))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let todosResponse = try decoder.decode(TodoResponse.self, from: data)
                        completion(.success(todosResponse))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }
            
            dataTask.resume()
        }
    }
}
