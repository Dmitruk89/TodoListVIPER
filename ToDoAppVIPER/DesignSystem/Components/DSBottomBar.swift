//
//  BottomBar.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

import UIKit

enum DSBottomBar {
    static let height: CGFloat = 48 + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
    static let countLabelLeadingInset: CGFloat = DSSpacing.horizontal
    static let buttonTrailingInset: CGFloat = DSSpacing.horizontal
    static let buttonSize: CGFloat = 28
    static let buttonTopInset: CGFloat = 10
    static let buttonColor = DSColor.tint
    
    static let countLabelColor = DSColor.primaryText
    static let countLabelFont = DSTypography.subheadline
    
    static let borderHeight: CGFloat = 1.0 / UIScreen.main.scale
    static let borderType: UIColor = DSColor.separator
    
    static let countLabelText = "Задач"
    static let newTodoIconName = "square.and.pencil"
}
