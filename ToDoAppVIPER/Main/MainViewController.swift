//
//  ViewController.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 25.11.25.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func showTodos(_ todos: [AppTodo])
    func showError(_ message: String)
}

final class MainViewController: UIViewController {

    var presenter: MainPresenterProtocol!

    private let tableView = UITableView()
    private var todos: [AppTodo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Задачи"

        setupTableView()
        presenter.viewDidLoad()
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

extension MainViewController: MainViewProtocol {
    func showTodos(_ todos: [AppTodo]) {
        self.todos = todos
        tableView.reloadData()
    }

    func showError(_ message: String) {
        print("❌ Error: \(message)")
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = "completed: \(todo.completed)"
        return cell
    }
}
