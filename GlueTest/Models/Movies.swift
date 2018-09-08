//
//  Movie.swift
//  GlueTest
//
//  Created by Andy Bennett on 08/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

struct Movies: Codable
{
    let data: [Movie]
}

struct Movie: Codable, Equatable
{
    let genre: String
    let id: Int
    let poster: URL
    let title: String
    let year: String
}
