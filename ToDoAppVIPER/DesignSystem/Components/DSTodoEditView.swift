//
//  DSTodoEditView.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 02.12.25.
//

import UIKit

enum DSTodoEditView {
    
    // MARK: - Spacing
    static let stackSpacing: CGFloat = DSSpacing.vertical
    static let horizontalPadding: CGFloat = DSSpacing.horizontal
    static let topPadding: CGFloat = 30
    static let textViewMinHeight: CGFloat = 200
    
    // MARK: - Title Label
    enum TitleTextView {
        static let font: UIFont = DSTypography.viewTitle
        static let textColor: UIColor = DSColor.primaryText
        static let backgroundColor: UIColor = .clear
        static let isScrollEnabled: Bool = false
    }
    
    // MARK: - Date Label
    enum DateLabel {
        static let font: UIFont = DSTypography.footnote
        static let textColor: UIColor = DSColor.secondaryText
        static let numberOfLines: Int = 0
    }
    
    // MARK: - TextView
    enum DescriptionTextView {
        static let font: UIFont = DSTypography.viewDescription
        static let textColor: UIColor = DSColor.primaryText
        static let backgroundColor: UIColor = .clear
        static let isScrollEnabled: Bool = true
    }
    
    // MARK: - General
    static let viewBackgroundColor: UIColor = DSColor.darkBackground
}
