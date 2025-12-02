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
    private let textView = UITextView()
    
    private var currentTodo: AppTodo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = DSColor.darkBackground
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    func display(todo: AppTodo) {
        currentTodo = todo

        title = todo.title
        dateLabel.text = DateUtility.formatShortDate(todo.createdAt)

        textView.text = todo.description
        placeCursorAtEnd()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.textView.becomeFirstResponder()
        }
    }
    
    private func setupUI() {
        dateLabel.font = DSTypography.footnote
        dateLabel.textColor = DSColor.secondaryText
        dateLabel.numberOfLines = 0

        textView.font = DSTypography.subheadline
        textView.textColor = DSColor.primaryText
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.isScrollEnabled = true
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, textView])
        stack.axis = .vertical
        stack.spacing = DSSpacing.vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSSpacing.horizontal),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSSpacing.horizontal),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DSSpacing.large),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    
    private func placeCursorAtEnd() {
        let endPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: endPosition, to: endPosition)
    }
}

extension TodoEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard var todo = currentTodo else { return }
        todo.description = textView.text
        presenter.updateDescription(todo)
    }
}
