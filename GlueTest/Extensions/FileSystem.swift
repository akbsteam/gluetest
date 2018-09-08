//
//  FileSystem.swift
//  GlueTest
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

typealias FetchCompletion = (Data?) -> Void

struct FileSystem {
    
    private static let fileManager = FileManager.default
    static let moviesCache = fileManager.cachesDirectory.appendingPathComponent("movies")
    
    enum Status
    {
        case existing(URL)
        case new(URL)
        
        var isNew: Bool {
            switch self {
            case .new:
                return true
            default:
                return false
            }
        }
        
        var url: URL {
            switch self {
            case let .new(url), let .existing(url):
                return url
            }
        }
    }
    
    static func createCache(at directory: URL) throws
    {
        try fileManager.createDirectory(at: directory,
                                        withIntermediateDirectories: false,
                                        attributes: nil)
    }
    
    static func cacheDirectoryURL(at directory: URL,
                                  against now: Date = Date(),
                                  maxAge: TimeInterval = 100) throws -> Status
    {
        let nowTime = now.timeIntervalSinceReferenceDate
        let newURL = directory.appendingPathComponent("\(nowTime)")
        
        // there's no cache directory, so create it and return the new URL
        if !fileManager.fileExists(atURL: directory) {
            try FileSystem.createCache(at: directory)
            return .new(newURL)
        }
        
        // the moviesCache directory is empty, so return the new URL
        guard let cacheFile = try fileManager.firstFile(in: directory)
            else { return .new(newURL) }
        
        // there is a cache file, but either
        //    - its got an invalid filename (ie, not based on timeInterval)
        //    - its too old
        // so recreate the cache directory, and return the new URL
        if !cacheFile.validFileDate(against: now, maxAge: maxAge) {
            try fileManager.removeItem(at: directory)
            try FileSystem.createCache(at: directory)
            return .new(newURL)
        }
        
        // return the existing cache file url
        return .existing(cacheFile)
    }
}

extension FileManager
{
    var documentsDirectory: URL {
        return urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    var cachesDirectory: URL {
        return urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    func firstFile(in url: URL) throws -> URL?
    {
        return try contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).first
    }
    
    func fileExists(atURL url: URL) -> Bool
    {
        return fileExists(atPath: url.path)
    }
    
    func removeFileIfExists(at url: URL) throws
    {
        guard fileExists(atURL: url)
            else { return }
        
        try removeItem(at: url)
    }
}
