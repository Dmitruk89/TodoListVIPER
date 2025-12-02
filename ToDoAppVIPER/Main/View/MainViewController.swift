//
//  ViewController.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 25.11.25.
//

import UIKit
import Combine

protocol MainViewProtocol: AnyObject {
    func showTodos(_ todos: [AppTodo])
    func showError(_ message: String)
    func updateTodo(_ todo: AppTodo)
}

final class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    
    private let searchBarView = TodoSearchBarView()
    private let tableView = UITableView()
    private let bottomBarView = BottomBarView()
    private var todos: [AppTodo] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        title = DSMainView.Navigation.title

        let backItem = UIBarButtonItem()
        backItem.title = DSMainView.Navigation.backButtonTitle
        navigationItem.backBarButtonItem = backItem
        
        setupNavigationBarAppearance()
        setupViewsAndConstraints()
        bind()
        
        searchBarView.delegate = self
        bottomBarView.delegate = self
        
        presenter.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    private func bind() {
        CoreDataService.shared.changesPublisher
            .sink { [weak self] in
                self?.presenter.viewDidLoad()
            }
            .store(in: &cancellables)
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
        
        view.addSubview(bottomBarView)
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = DSMainView.TableView.rowHeight
        tableView.separatorStyle = DSMainView.TableView.separatorStyle
        tableView.separatorColor = DSMainView.Colors.separator
        tableView.backgroundColor = DSMainView.Colors.tableBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: DSMainView.Layout.tableTopInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: DSBottomBar.height)
        ])
    }
}

extension MainViewController: MainViewProtocol {
    func showTodos(_ todos: [AppTodo]) {
        self.todos = todos
        tableView.reloadData()
        updateBottomBar()
    }
    
    func showError(_ message: String) {
        print("❌ Error: \(message)")
    }
    
    func updateTodo(_ todo: AppTodo) {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }
        todos[index] = todo
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateBottomBar() {
        bottomBarView.configure(with: todos.count)
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
            self.presenter.edit(todo)
        }
        
        let share = UIAction(title: DSContextMenu.shareTitle,
                             image: DSContextMenu.shareImage) { _ in
            print("Share tapped")
            // TODO: presenter.share(todo)
        }
        
        let delete = UIAction(title: DSContextMenu.deleteTitle,
                              image: DSContextMenu.deleteImage,
                              attributes: DSContextMenu.deleteAttributes) { _ in
            self.presenter.deleteTodo(todo)
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

        presenter.updateTodo(updatedTodo)
    }
}

extension MainViewController: BottomBarViewDelegate {
    func didTapNewTodoButton() {
        presenter.createTodo()
    }
}
