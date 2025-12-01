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
        bar.placeholder = "Search"
        bar.searchBarStyle = .default
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        if let textField = bar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .label
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
        appearance.backgroundColor = .black
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    private func makeContextMenu(for todo: AppTodo) -> UIMenu {
        let edit = UIAction(title: "Редактировать",
                            image: UIImage(systemName: "pencil")) { _ in
            print("Edit tapped")
            // TODO: presenter.edit(todo)
        }
        
        let share = UIAction(title: "Поделиться",
                             image: UIImage(systemName: "square.and.arrow.up")) { _ in
            print("Share tapped")
            // TODO: presenter.share(todo)
        }
        
        let delete = UIAction(title: "Удалить",
                              image: UIImage(systemName: "trash"),
                              attributes: .destructive) { _ in
            print("Delete tapped")
            // TODO: presenter.delete(todo)
        }
        
        return UIMenu(title: "", children: [edit, share, delete])
    }
    
    private func setupViewsAndConstraints() {
        view.addSubview(searchBar)
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        tableView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
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

extension UIContextMenuConfiguration {
    static func withPreview(_ view: UIView,
                            actions: @escaping () -> UIMenu) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: {
            let vc = UIViewController()
            vc.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.backgroundColor = .black
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                view.topAnchor.constraint(equalTo: vc.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
            ])
            
            vc.preferredContentSize = CGSize(width: UIView.noIntrinsicMetric, height: 100)
            
            return vc
        }, actionProvider: { _ in actions() })
    }
}
