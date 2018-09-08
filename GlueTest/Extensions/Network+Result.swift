//
//  ModelCoordinator.swift
//  GlueTest
//
//  Created by Andy Bennett on 09/09/2018.
//  Copyright © 2018 Andy Bennett. All rights reserved.
//

import Foundation

extension URLSession
{
    enum NetworkError: Error {
        case unknown
    }
    
    enum Result {
        case success((Data, URLResponse))
        case failure((Error, URLResponse?))
        
        var value: Data? {
            guard case let .success(value, _) = self
                else { return nil }
            
            return value
        }
        
        var error: Error? {
            guard case let .failure(error, _) = self
                else { return nil }
            
            return error
        }
        
        var urlResponse: URLResponse? {
            switch self {
            case .success(_, let response):
                return response
            case .failure(_, let response):
                return response
            }
        }
    }
    
    func fetch(from url: URL, result: @escaping (Result) -> Void)
    {
        dataTask(with: url) { (data, response, error) in
            if let data = data, let response = response {
                result(.success((data, response)))
            } else if let error = error {
                result(.failure((error, response)))
            } else {
                result(.failure((NetworkError.unknown, response)))
            }
        }
        .resume()
    }
}

extension URLSession.Result
{
    func map<U>(_ transform: (URLSession.Result) -> U) -> U
    {
        return transform(self)
    }
}
