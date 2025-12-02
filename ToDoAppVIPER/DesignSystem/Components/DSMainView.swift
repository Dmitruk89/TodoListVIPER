//
//  DSMain.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//


import UIKit

enum DSMainView {

    enum Layout {
        static let tableTopInset: CGFloat = DSSpacing.vertical
    }

    enum Colors {
        static let background = DSColor.darkBackground
        static let tableBackground = DSColor.darkBackground
        static let separator = DSColor.secondaryText
    }

    enum Navigation {
        static let title = "Задачи"
        static let backButtonTitle = "Назад"
    }

    enum TableView {
        static let rowHeight = UITableView.automaticDimension
        static let separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    }
}
