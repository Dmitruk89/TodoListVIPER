//
//  ViewController.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 25.11.25.
//

import UIKit

class ViewController: UIViewController {

    private let todoService: TodoAPIServiceProtocol = TodoAPIService()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Задачи"

        loadTodos()
    }

    private func loadTodos() {
        todoService.fetchTodos { result in
            switch result {
            case .success(let response):
                for todo in response.todos.prefix(5) {
                    print("\(todo.todo)")
                }
            case .failure(let error):
                print("Error loading todos: \(error)")
            }
        }
    }
}
