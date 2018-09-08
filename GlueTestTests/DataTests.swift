//
//  GlueTestTests.swift
//  GlueTestTests
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import XCTest
@testable import GlueTest

class DataTests: XCTestCase
{
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
    
    func test_jsonDecodesCorrectly()
    {
        // when
        let data: Movies? = TestData.testBundle.json(named: "movies")
        
        // then
        guard let sut = data, sut.data.count == 25
            else { XCTFail(); return }

        // Codable is reliable, so this is really just a spike test
        XCTAssertEqual(sut.data[0], TestData.Example.dunkirk)
        XCTAssertEqual(sut.data[13], TestData.Example.ted2)
        XCTAssertEqual(sut.data[22], TestData.Example.abandoned)
    }
    
    func test_usesCache()
    {
        // given
        let date = Date()
        let testDate = date.modified(bySeconds: -50)
        let validDirectory = FileSystem.moviesCache.appendingPathComponent("\(testDate)")
        writeTest(directory: validDirectory)
        
        // when
        let urlStatus = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache, against: date)
        
        // then
        urlStatus.test(expectedCount: 0)
    }
    
    func test_notUsesCache()
    {
        let urlStatus = try! FileSystem.cacheDirectoryURL(at: FileSystem.moviesCache)
        urlStatus.test(expectedCount: 25)
    }
    
    func test_model_usesCache()
    {
        // given
        let date = Date()
        let testDate = date.modified(bySeconds: -50)
        let validDirectory = FileSystem.moviesCache.appendingPathComponent("\(testDate)")
        writeTest(directory: validDirectory)
        
        // then
        let expected = expectation(description: "model_usesCache")
        
        Model.asyncFactory { model in
            expected.fulfill()
            XCTAssertEqual(model.movies.count, 0)
        }
        
        self.wait(for: [expected], timeout: 5)
    }
    
    func test_model_notUsesCache()
    {
        let expected = expectation(description: "model_notUsesCache")
        
        Model.asyncFactory { model in
            expected.fulfill()
            XCTAssertEqual(model.movies.count, 25)
        }
        
        self.wait(for: [expected], timeout: 5)
    }
    
    func writeTest(directory: URL, file: StaticString = #file, line: UInt = #line)
    {
        let fileName = directory.appendingPathComponent("model.json")
        
        try! FileSystem.createCache(at: FileSystem.moviesCache)
        
        try! fileManager.createDirectory(at: directory,
                                         withIntermediateDirectories: false,
                                         attributes: nil)
        
        try! "{ \"data\": [] }".write(to: fileName, atomically: true, encoding: .utf8)
        
        XCTAssertTrue(fileManager.fileExists(atURL: fileName))
    }
}

private extension FileSystem.Status
{
    func test(expectedCount: Int,
              file: StaticString = #file,
              line: UInt = #line)
    {
        func testData(_ data: Data?) {
            guard let data = data else { XCTFail(); return }
            
            let json = try! JSONDecoder().decode(Movies.self, from: data)
            XCTAssertEqual(json.data.count, expectedCount, file: file, line: line)
        }
        
        switch self {
        case .existing(let url):
            let data = try! Data(contentsOf: url.appendingPathComponent("model.json"))
            testData(data)
            
        case .new:
            let data = TestData.testBundle.data(named: "movies")
            testData(data)
        }
    }
}
