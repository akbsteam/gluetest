//
//  Images.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import UIKit

extension URLSession
{
    func fetchImage(from url: URL, into directory: URL, completion: @escaping (URL, UIImage) -> Void)
    {
        let fileManager = FileManager.default
        let fileURL = directory.appendingPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atURL: fileURL),
            let image = UIImage(contentsOfFile: fileURL.path)
        {
            completion(url, image)
            return
        }
        
        fetch(from: url) { result in
            guard let data = result.value,
                let image = UIImage(data: data)
                else { return }
            
            try? fileManager.removeFileIfExists(at: fileURL)
            try? data.write(to: fileURL)
            
            completion(url, image)
        }
    }
}
