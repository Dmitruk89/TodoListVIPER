//
//  BottomBarViewDelegate.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

import UIKit

protocol BottomBarViewDelegate: AnyObject {
    func didTapNewTodoButton()
}

final class BottomBarView: UIView {
    
    weak var delegate: BottomBarViewDelegate?

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = DSBottomBar.countLabelColor
        label.font = DSBottomBar.countLabelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newTodoButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(systemName: DSBottomBar.newTodoIconName)
        button.setImage(icon, for: .normal)
        button.tintColor = DSBottomBar.buttonColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = DSBottomBar.borderType
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = DSColor.background
        newTodoButton.addTarget(self, action: #selector(newTodoButtonTapped), for: .touchUpInside)
        
        addSubview(topBorder)
        addSubview(countLabel)
        addSubview(newTodoButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: DSBottomBar.borderHeight)
        ])
        
        NSLayoutConstraint.activate([
            newTodoButton.widthAnchor.constraint(equalToConstant: DSBottomBar.buttonSize),
            newTodoButton.heightAnchor.constraint(equalToConstant: DSBottomBar.buttonSize),
            newTodoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSBottomBar.buttonTrailingInset),
            newTodoButton.topAnchor.constraint(equalTo: topAnchor, constant: DSBottomBar.buttonTopInset),
            
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: newTodoButton.centerYAnchor)
        ])
    }
    
    func configure(with count: Int) {
        countLabel.text = "\(count) \(DSBottomBar.countLabelText)"
        countLabel.textColor = DSBottomBar.countLabelColor
    }
    
    @objc private func newTodoButtonTapped() {
        delegate?.didTapNewTodoButton()
    }
}
