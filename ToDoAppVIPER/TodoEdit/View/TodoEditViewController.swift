//
//  TodoEditViewController.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//


import UIKit
import Combine

protocol TodoEditViewInput: AnyObject {
    func display(todo: AppTodo)
}

final class TodoEditViewController: UIViewController, TodoEditViewInput {
    
    var presenter: TodoEditViewOutput!
    
    private let titleChanges = PassthroughSubject<AppTodo, Never>()
    private let descriptionChanges = PassthroughSubject<AppTodo, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let titleTextView = UITextView()
    private let dateLabel = UILabel()
    private let textView = UITextView()
    
    private var currentTodo: AppTodo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        setupUI()
        bindTextChanges()
        presenter.viewDidLoad()
    }
    
    func display(todo: AppTodo) {
        currentTodo = todo

        titleTextView.text = todo.title
        dateLabel.text = DateUtility.formatShortDate(todo.createdAt)

        textView.text = todo.description
        placeCursorAtEnd()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.textView.becomeFirstResponder()
        }
    }
    
    private func bindTextChanges() {
        titleChanges
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
            .sink { [weak self] todo in
                self?.presenter.updateTodo(todo)
            }
            .store(in: &cancellables)

        descriptionChanges
            .debounce(for: .milliseconds(600), scheduler: RunLoop.main)
            .sink { [weak self] todo in
                self?.presenter.updateTodo(todo)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = DSTodoEditView.viewBackgroundColor
        
        titleTextView.font = DSTodoEditView.TitleTextView.font
        titleTextView.textColor = DSTodoEditView.TitleTextView.textColor
        titleTextView.backgroundColor = DSTodoEditView.TitleTextView.backgroundColor
        titleTextView.isScrollEnabled = DSTodoEditView.TitleTextView.isScrollEnabled
        titleTextView.delegate = self
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        titleTextView.isScrollEnabled = false
        
        dateLabel.font = DSTodoEditView.DateLabel.font
        dateLabel.textColor = DSTodoEditView.DateLabel.textColor
        dateLabel.numberOfLines = DSTodoEditView.DateLabel.numberOfLines

        textView.font = DSTodoEditView.DescriptionTextView.font
        textView.textColor = DSTodoEditView.DescriptionTextView.textColor
        textView.backgroundColor = DSTodoEditView.DescriptionTextView.backgroundColor
        textView.delegate = self
        textView.isScrollEnabled = DSTodoEditView.DescriptionTextView.isScrollEnabled
        
        let stack = UIStackView(arrangedSubviews: [titleTextView, dateLabel, textView])
        stack.axis = .vertical
        stack.spacing = DSTodoEditView.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DSTodoEditView.horizontalPadding),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DSTodoEditView.horizontalPadding),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

        if textView === titleTextView {
            todo.title = textView.text
            currentTodo = todo
            titleChanges.send(todo)
        } else if textView === self.textView {
            todo.description = textView.text
            currentTodo = todo
            descriptionChanges.send(todo)
        }
    }
}
