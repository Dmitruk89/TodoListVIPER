//
//  DSContextMenu.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//

import UIKit

enum DSContextMenu {
    static let editTitle = "Редактировать"
    static let editImage = UIImage(systemName: "pencil")
    
    static let shareTitle = "Поделиться"
    static let shareImage = UIImage(systemName: "square.and.arrow.up")
    
    static let deleteTitle = "Удалить"
    static let deleteImage = UIImage(systemName: "trash")
    static let deleteAttributes: UIMenuElement.Attributes = .destructive
}
