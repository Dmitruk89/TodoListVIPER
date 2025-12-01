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
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = DSSearchBar.placeholder
        bar.searchBarStyle = DSSearchBar.style
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        if let textField = bar.value(forKey: "searchField") as? UITextField {
            textField.textColor = DSSearchBar.textColor
        }
        return bar
    }()
    
    private let tableView = UITableView()
    private var todos: [AppTodo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        title = "Задачи"
        
        setupNavigationBarAppearance()
        setupViewsAndConstraints()
        
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
        view.addSubview(searchBar)
        
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
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: DSSearchBar.height),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: DSSpacing.vertical),
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
