//
//  TodoTableViewCell.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//


import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func todoCellDidToggleStatus(_ cell: TodoTableViewCell)
}

final class TodoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TodoTableViewCell"
    
    weak var delegate: TodoTableViewCellDelegate?
    
    private var currentTodo: AppTodo?
    
    private let statusIndicator = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DSTypography.headline
        label.numberOfLines = 0
        label.textColor = DSColor.primaryText
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = DSTypography.subheadline
        label.numberOfLines = 2
        label.textColor = DSColor.primaryText
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = DSTypography.subheadline
        label.textColor = DSColor.secondaryText
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = DSColor.darkBackground
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        statusIndicator.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
        statusIndicator.addGestureRecognizer(tap)
    }
    
    @objc private func statusTapped() {
        delegate?.todoCellDidToggleStatus(self)
    }

    private func setupLayout() {
        [statusIndicator, titleLabel, detailLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        statusIndicator.tintColor = DSColor.tint

        NSLayoutConstraint.activate([
            statusIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSSpacing.horizontal),
            statusIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSSpacing.vertical),
            statusIndicator.widthAnchor.constraint(equalToConstant: DSStatusIcon.size),
            statusIndicator.heightAnchor.constraint(equalToConstant: DSStatusIcon.size),
            
            titleLabel.leadingAnchor.constraint(equalTo: statusIndicator.trailingAnchor, constant: DSSpacing.large),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSSpacing.vertical),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSSpacing.horizontal),
            
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSSpacing.horizontal),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DSSpacing.small),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: DSSpacing.small),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DSSpacing.vertical)
        ])
    }
    
    func configure(with todo: AppTodo) {
        currentTodo = todo

        let isDone = todo.completed
        
        var titleAttributes: [NSAttributedString.Key: Any] = [
            .font: DSTodoCell.titleFont,
            .foregroundColor: isDone ? DSTodoCell.titleCompletedColor : DSTodoCell.titleColor
        ]
        
        if isDone {
            titleAttributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        } else {
            titleAttributes[.strikethroughStyle] = NSUnderlineStyle().rawValue
        }
        
        titleLabel.attributedText = NSAttributedString(string: todo.title, attributes: titleAttributes)

        detailLabel.textColor = isDone ? DSTodoCell.detailCompletedColor : DSTodoCell.detailColor
        detailLabel.font = DSTodoCell.detailFont
        detailLabel.text = todo.description

        dateLabel.text = DateUtility.formatShortDate(todo.createdAt)

        let statusImageName = todo.completed ? DSStatusIcon.completed : DSStatusIcon.pending
        statusIndicator.image = UIImage(systemName: statusImageName)
        statusIndicator.tintColor = DSTodoCell.iconTint
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
        dateLabel.text = nil
        statusIndicator.image = nil
    }
}
