//
//  Optional+Apply.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

extension Optional
{
    func apply(_ transform: (Wrapped) throws -> Void) rethrows
    {
        _ = try self.map(transform)
    }
}
