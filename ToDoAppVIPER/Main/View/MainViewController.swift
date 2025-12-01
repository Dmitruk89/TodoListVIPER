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
    func updateTodo(_ todo: AppTodo)
}

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    
    private let searchBarView = TodoSearchBarView()
    private let tableView = UITableView()
    private var todos: [AppTodo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        title = "Задачи"
        
        setupNavigationBarAppearance()
        setupViewsAndConstraints()
        searchBarView.delegate = self
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBarAppearance() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DSColor.black
        
        appearance.titleTextAttributes = [
            .foregroundColor: DSColor.primaryText
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: DSColor.primaryText
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = DSColor.tint
    }
    
    private func setupViewsAndConstraints() {
        view.addSubview(searchBarView)
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = DSColor.secondaryText
        tableView.backgroundColor = DSColor.darkBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: DSSearchBar.height),
            
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: DSSpacing.vertical),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    func updateTodo(_ todo: AppTodo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index] = todo
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension MainViewController: TodoSearchBarDelegate {
    func searchBar(_ searchBar: TodoSearchBarView, didUpdateQuery query: String) {
        presenter.filterTodos(with: query)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier, for: indexPath) as? TodoTableViewCell else {
            fatalError("Could not dequeue TodoTableViewCell")
        }
        
        let todo = todos[indexPath.row]
        cell.delegate = self 
        cell.configure(with: todo)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    private func makeContextMenu(for todo: AppTodo) -> UIMenu {
        let edit = UIAction(title: DSContextMenu.editTitle,
                            image: DSContextMenu.editImage) { _ in
            print("Edit tapped")
            // TODO: presenter.edit(todo)
        }
        
        let share = UIAction(title: DSContextMenu.shareTitle,
                             image: DSContextMenu.shareImage) { _ in
            print("Share tapped")
            // TODO: presenter.share(todo)
        }
        
        let delete = UIAction(title: DSContextMenu.deleteTitle,
                              image: DSContextMenu.deleteImage,
                              attributes: DSContextMenu.deleteAttributes) { _ in
            print("Delete tapped")
            // TODO: presenter.delete(todo)
        }
        
        return UIMenu(title: "", children: [edit, share, delete])
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {

        let todo = todos[indexPath.row]
        let preview = TodoPreviewView(todo: todo)
        
        return .withPreview(preview) {
            self.makeContextMenu(for: todo)
        }
    }
}

extension MainViewController: TodoTableViewCellDelegate {
    func todoCellDidToggleStatus(_ cell: TodoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let oldTodo = todos[indexPath.row]

        var updatedTodo = oldTodo
        updatedTodo.completed.toggle()

        todos[indexPath.row] = updatedTodo
        cell.configure(with: updatedTodo)

        presenter.updateTodo(updatedTodo)
    }
}
