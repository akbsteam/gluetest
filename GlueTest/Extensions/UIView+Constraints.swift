//
//  UIView+Constraints.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import UIKit

extension UIView
{
    func addEqualSubview(_ view: UIView, with edgeInsets: UIEdgeInsets = .zero)
    {
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: -edgeInsets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edgeInsets.bottom),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -edgeInsets.left),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edgeInsets.right)
        ])
    }
}
