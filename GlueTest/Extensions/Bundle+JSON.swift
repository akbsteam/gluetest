//
//  Bundle+JSON.swift
//  GlueTest
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

extension Bundle
{
    public func data(named name: String) -> Data?
    {
        guard
            let url = self.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else { return nil }
        
        return data
    }
    
    public func json<T: Decodable>(named name: String) -> T?
    {
        guard
            let data = self.data(named: name),
            let decoded = try? JSONDecoder().decode(T.self, from: data)
            else { return nil }
        
        return decoded
    }
}
