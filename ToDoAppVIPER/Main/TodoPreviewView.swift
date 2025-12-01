//
//  TodoPreviewView.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//

import UIKit

final class TodoPreviewView: UIView {

    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let dateLabel = UILabel()

    init(todo: AppTodo) {
        super.init(frame: .zero)
        setupUI()
        configure(todo)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = UIColor(white: 0.15, alpha: 1)

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white

        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.numberOfLines = 0
        detailLabel.textColor = .white

        dateLabel.font = .preferredFont(forTextStyle: .footnote)
        dateLabel.textColor = .lightGray

        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 6

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    private func configure(_ todo: AppTodo) {
        titleLabel.text = todo.title
        detailLabel.text = todo.description

        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy"
        dateLabel.text = df.string(from: todo.createdAt)
    }
}
