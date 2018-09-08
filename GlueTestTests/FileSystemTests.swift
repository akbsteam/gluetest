//
//  FileSystemTests.swift
//  GlueTestTests
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import XCTest
@testable import GlueTest

class FileSystemTests: XCTestCase {
    
    let fileManager = FileManager.default
    
    override func setUp()
    {
        super.setUp()
        
        try! fileManager.removeFileIfExists(at: FileSystem.moviesCache)
    }
    
    override func tearDown()
    {
        try! fileManager.removeFileIfExists(at: FileSystem.moviesCache)
        
        super.tearDown()
    }
    
    func test_createsCacheDirectory()
    {
        // given
        let directory = FileSystem.moviesCache
        XCTAssertFalse(fileManager.fileExists(atPath: directory.path))
        
        // when
        XCTAssertNoThrow(try FileSystem.createCache(at: FileSystem.moviesCache))
        
        // then
        XCTAssertTrue(fileManager.fileExists(atPath: directory.path))
    }
    
    func test_getsNewMoviesCacheFileURL_ifDirectoryMissing()
    {
        // given
        let date = Date()
        XCTAssertFalse(fileManager.fileExists(atURL: FileSystem.moviesCache))
        
        // when
        let sut = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache, against: date, maxAge: 100)
        
        // then
        XCTAssertTrue(fileManager.fileExists(atURL: FileSystem.moviesCache))
        XCTAssertEqual(sut.url.lastPathComponent, "\(date.timeIntervalSinceReferenceDate)")
    }
    
    func test_getsNewMoviesCacheFileURL_ifDirectoryEmpty()
    {
        // given
        let date = Date()
        XCTAssertFalse(fileManager.fileExists(atURL: FileSystem.moviesCache))
        
        // when
        try! FileSystem.createCache(at: FileSystem.moviesCache)
        XCTAssertTrue(fileManager.fileExists(atURL: FileSystem.moviesCache))
        let sut = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache, against: date, maxAge: 100)

        // then
        XCTAssertTrue(sut.isNew)
        XCTAssertEqual(sut.url.lastPathComponent, "\(date.timeIntervalSinceReferenceDate)")
    }
    
    func test_getsMoviesCacheFileURL_ifDirectoryContainsInvalidFileName()
    {
        // given
        let date = Date()
        let invalidDirectory = FileSystem.moviesCache.appendingPathComponent("test")
        
        // when
        writeTest(directory: invalidDirectory)
        let sut = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache, against: date, maxAge: 100)
        
        // then
        XCTAssertTrue(sut.isNew)
        XCTAssertEqual(sut.url.lastPathComponent, "\(date.timeIntervalSinceReferenceDate)")
        
        // confirm that the invalid file has also been removed
        XCTAssertFalse(fileManager.fileExists(atURL: invalidDirectory))
    }
    
    func test_getsNewMoviesCacheFileURL_ifDirectoryContainsValidButOldFileName()
    {
        // given
        let date = Date()
        let testDate = date.modified(bySeconds: -150)
        let validButOldDirectory = FileSystem.moviesCache.appendingPathComponent("\(testDate)")

        // when
        writeTest(directory: validButOldDirectory)
        
        let sut = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache, against: date, maxAge: 100)

        // then
        XCTAssertTrue(sut.isNew)
        XCTAssertEqual(sut.url.lastPathComponent, "\(date.timeIntervalSinceReferenceDate)")
        
        // confirm that the old file has also been removed
        XCTAssertFalse(fileManager.fileExists(atURL: validButOldDirectory))
    }
    
    func test_getsExistingMoviesCacheFileURL_ifDirectoryContainsValidFileName()
    {
        // given
        let date = Date()
        let testDate = date.modified(bySeconds: -50)
        let validDirectory = FileSystem.moviesCache.appendingPathComponent("\(testDate)")
        
        // when
        writeTest(directory: validDirectory)
        let sut = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache, against: date, maxAge: 100)
        
        // then
        XCTAssertFalse(sut.isNew)
        XCTAssertEqual(sut.url.lastPathComponent, "\(testDate)")
        
        // confirm that the existing file has not been removed
        XCTAssertTrue(fileManager.fileExists(atURL: validDirectory))
    }
    
    func writeTest(directory: URL, file: StaticString = #file, line: UInt = #line)
    {
        let fileName = directory.appendingPathComponent("model.json")
        
        try! FileSystem.createCache(at: FileSystem.moviesCache)
        
        try! fileManager.createDirectory(at: directory,
                                         withIntermediateDirectories: false,
                                         attributes: nil)
        
        try! "Test".write(to: fileName, atomically: true, encoding: .utf8)
        
        XCTAssertTrue(fileManager.fileExists(atURL: fileName))
    }
}
