//
//  Reusable.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView
{
    func dequeueCell<T: Reusable>(at indexPath: IndexPath) -> T
    {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func register<T: Reusable>(_ reusable: T.Type)
    {
        self.register(reusable, forCellWithReuseIdentifier: reusable.reuseIdentifier)
    }
}
