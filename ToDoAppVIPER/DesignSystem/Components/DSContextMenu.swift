//
//  DSContextMenu.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//

import UIKit

enum DSContextMenu {
    static let editTitle = "Редактировать"
    static let editImage = UIImage(named: "ds_edit")
    
    static let shareTitle = "Поделиться"
    static let shareImage = UIImage(named: "ds_share")
    
    static let deleteTitle = "Удалить"
    static let deleteImage = UIImage(named: "ds_delete")
    static let deleteAttributes: UIMenuElement.Attributes = .destructive
}
