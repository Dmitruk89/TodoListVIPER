//
//  UIContextMenuConfiguration + Preview.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//

import UIKit

extension UIContextMenuConfiguration {
    static func withPreview(_ view: UIView,
                            actions: @escaping () -> UIMenu) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: {
            let vc = UIViewController()
            vc.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.backgroundColor = DSTodoPreview.backgroundColor
            
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
                view.topAnchor.constraint(equalTo: vc.view.topAnchor),
                view.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
            ])
            
            vc.preferredContentSize = CGSize(width: UIView.noIntrinsicMetric,
                                             height: DSTodoPreview.preferredHeight)
            
            return vc
        }, actionProvider: { _ in actions() })
    }
}
