//
//  TodoEditViewController.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//


import UIKit

protocol TodoEditViewInput: AnyObject {
    func display(todo: AppTodo)
}

final class TodoEditViewController: UIViewController, TodoEditViewInput {
    
    var presenter: TodoEditViewOutput!
    
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = DSColor.darkBackground
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    func display(todo: AppTodo) {
        title = todo.title
        
        dateLabel.text = DateUtility.formatShortDate(todo.createdAt)
        descriptionLabel.text = todo.description
    }
    
    private func setupUI() {
        dateLabel.font = DSTypography.footnote
        dateLabel.textColor = DSColor.secondaryText
        dateLabel.numberOfLines = 0

        descriptionLabel.font = DSTypography.subheadline
        descriptionLabel.textColor = DSColor.primaryText
        descriptionLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = DSSpacing.vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSSpacing.horizontal),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSSpacing.horizontal),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DSSpacing.large)
        ])
    }
}
