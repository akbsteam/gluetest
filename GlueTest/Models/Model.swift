//
//  Model.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

private struct Constants
{
    static let remoteUrl = URL(string: "https://movies-sample.herokuapp.com/api/movies")!
    static let localUrl = Bundle.main.url(forResource: "movies", withExtension: "json")!
    
    static let fileName = "model.json"
    static let maxAge: TimeInterval = 10 * 60
}

struct Model
{
    let cacheFolder: URL
    let movies: [Movie]
}

extension Model {
    
    static func asyncFactory(completion: @escaping (Model) -> Void) {
        
        do {
            func createModel(cacheFolder: URL, data: Data) {
                guard let movies = try? JSONDecoder().decode(Movies.self, from: data)
                    else { return }
                
                completion(Model(cacheFolder: cacheFolder, movies: movies.data))
            }
            
            let urlStatus = try FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache,
                                                             maxAge: Constants.maxAge)
            
            switch urlStatus {
            case .existing(let url):
                let data = try Data(contentsOf: url.appendingPathComponent(Constants.fileName))
                createModel(cacheFolder: url, data: data)
                
            case .new(let url):
                let testMode = ProcessInfo().arguments.contains("UITestMode")
                let fileURL = testMode ? Constants.localUrl : Constants.remoteUrl
                
                URLSession.shared.fetch(from: fileURL) {
                    $0.value.apply {
                        try? $0.write(to: url.appendingPathComponent(Constants.fileName))
                        createModel(cacheFolder: url, data: $0)
                    }
                }
            }
            
        } catch {
            print(error.localizedDescription) // Normally we'd handle this better, eg logging
        }
    }
}
