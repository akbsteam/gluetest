//
//  URLTests.swift
//  GlueTestTests
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import XCTest
@testable import GlueTest

class URLTests: XCTestCase {
    
    func fileURL(from date: Date) -> URL {
        return URL(string: "file:///somedirectory/\(date.timeIntervalSinceReferenceDate).json")!
    }
    
    func test_invalidURL_returnsNil()
    {
        let url = URL(string: "file:///somedirectory/test.json")!
        XCTAssertNil(url.fileDateFromURL)
    }
    
    func test_validURL_returnsDate()
    {
        let url = fileURL(from: Date())
        XCTAssertNotNil(url.fileDateFromURL)
    }

    func test_validURL_isValidIfNew()
    {
        // given
        let date = Date()
        let testDate = Calendar.current.date(byAdding: .second, value: 50, to: date)!
        
        // when
        let timeInterval = fileURL(from: date).validFileDate(against: testDate, maxAge: 100)
        
        // then
        XCTAssertTrue(timeInterval)
    }
    
    func test_validURL_isInValidIfOld()
    {
        // given
        let date = Date()
        let url = URL(string: "file:///somedirectory/\(date.timeIntervalSinceReferenceDate).json")!
        let testDate = Calendar.current.date(byAdding: .second, value: 150, to: date)!
        
        // when
        let timeInterval = url.validFileDate(against: testDate, maxAge: 100)
        
        // then
        XCTAssertFalse(timeInterval)
    }
}


