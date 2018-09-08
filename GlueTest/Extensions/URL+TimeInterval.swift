//
//  URL+TimeInterval.swift
//  GlueTest
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

extension URL
{
    func validFileDate(against date: Date, maxAge: TimeInterval) -> Bool
    {
        guard let fileDate = self.fileDateFromURL
            else { return false }
        
        let diff = date.timeIntervalSince(fileDate)
        return diff < maxAge
    }
    
    var fileDateFromURL: Date? {
        
        guard let fileTime = Double(self.deletingPathExtension().lastPathComponent)
            else { return nil }
        
        return Date(timeIntervalSinceReferenceDate: fileTime)
    }
}
