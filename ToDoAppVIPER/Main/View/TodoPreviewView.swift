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
        backgroundColor = DSColor.background

        titleLabel.font = DSTypography.headline
        titleLabel.numberOfLines = 0
        titleLabel.textColor = DSColor.primaryText

        detailLabel.font = DSTypography.subheadline
        detailLabel.numberOfLines = 0
        detailLabel.textColor = DSColor.primaryText

        dateLabel.font = DSTypography.footnote
        dateLabel.textColor = DSColor.secondaryText

        let stack = UIStackView(arrangedSubviews: [titleLabel, detailLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = DSSpacing.medium

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSSpacing.horizontal),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSSpacing.horizontal),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: DSSpacing.medium),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DSSpacing.medium)
        ])
    }

    private func configure(_ todo: AppTodo) {
        titleLabel.text = todo.title
        detailLabel.text = todo.description
        dateLabel.text = DateUtility.formatShortDate(todo.createdAt)
    }
}
