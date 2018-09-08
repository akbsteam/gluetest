//
//  TestData.swift
//  GlueTestTests
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation
@testable import GlueTest

private class TestDataClass {}

struct TestData
{
    static let testBundle = Bundle(for: TestDataClass.self)
    
    struct Example
    {
        static let dunkirk = Movie(
            genre: "History",
            id: 912312,
            poster: URL(string: "https://goo.gl/1zUyyq")!,
            title: "Dunkirk",
            year: "2017"
        )
        
        static let ted2 = Movie(
            genre: "Fantasy",
            id: 12873192,
            poster: URL(string: "https://image.tmdb.org/t/p/w370_and_h556_bestv2/A7HtCxFe7Ms8H7e7o2zawppbuDT.jpg")!,
            title: "Ted 2",
            year: "2015"
        )
        
        static let abandoned = Movie(
            genre: "Drama",
            id: 38028,
            poster: URL(string: "https://raw.githubusercontent.com/cesarferreira/sample-data/master/public/posters/038028.jpg")!,
            title: "The Abandoned",
            year: "2015"
        )
    }
}

extension Date
{
    func modified(bySeconds seconds: Int) -> TimeInterval
    {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
            .timeIntervalSinceReferenceDate
    }
}
