//
//  TodoSearchBarDelegate.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//


import UIKit

protocol TodoSearchBarDelegate: AnyObject {
    func searchBar(_ searchBar: TodoSearchBarView, didUpdateQuery query: String)
}

final class TodoSearchBarView: UIView {

    weak var delegate: TodoSearchBarDelegate?

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        searchBar.delegate = self
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setQuery(_ text: String) {
        searchBar.text = text
    }
}

extension TodoSearchBarView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBar(self, didUpdateQuery: searchText)
    }
}
