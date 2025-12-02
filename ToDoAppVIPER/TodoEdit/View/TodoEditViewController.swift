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
        view.backgroundColor = DSTodoEditView.viewBackgroundColor
        
        dateLabel.font = DSTodoEditView.DateLabel.font
        dateLabel.textColor = DSTodoEditView.DateLabel.textColor
        dateLabel.numberOfLines = DSTodoEditView.DateLabel.numberOfLines

        textView.font = DSTodoEditView.DescriptionTextView.font
        textView.textColor = DSTodoEditView.DescriptionTextView.textColor
        textView.backgroundColor = DSTodoEditView.DescriptionTextView.backgroundColor
        textView.delegate = self
        textView.isScrollEnabled = DSTodoEditView.DescriptionTextView.isScrollEnabled
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, textView])
        stack.axis = .vertical
        stack.spacing = DSTodoEditView.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSTodoEditView.horizontalPadding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSTodoEditView.horizontalPadding),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DSTodoEditView.topPadding),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: DSTodoEditView.textViewMinHeight)
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
