//
//  TodoTableViewCell.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//


import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TodoTableViewCell"

    private let statusIndicator = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .top
        stack.spacing = 4
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        [statusIndicator, titleLabel, detailLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        statusIndicator.tintColor = .systemYellow
        
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 12
        let textSpacing: CGFloat = 4

        NSLayoutConstraint.activate([
            statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            statusIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            statusIndicator.widthAnchor.constraint(equalToConstant: 24),
            statusIndicator.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalPadding),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textSpacing),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: textSpacing),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
    
    func configure(with todo: AppTodo) {
        titleLabel.text = todo.title
        detailLabel.text = todo.description
        dateLabel.text = DateUtility.formatShortDate(todo.createdAt)
        
        if todo.completed {
            statusIndicator.image = UIImage(systemName: "checkmark.circle")
        } else {
            statusIndicator.image = UIImage(systemName: "circle")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = .label
        titleLabel.text = nil
        detailLabel.text = nil
        dateLabel.text = nil
        statusIndicator.image = nil
    }
}
