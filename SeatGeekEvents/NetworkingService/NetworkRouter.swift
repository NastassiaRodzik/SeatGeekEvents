//
//  NetworkRouter.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRouter {
    var method: HTTPMethod { get }
    var urlString: String { get }
    var path: String { get }
    var parametersString: String { get }
}

extension NetworkRouter {

    func asURLRequest() throws -> URLRequest {
        guard let requestURL = URL(string: urlString + path + parametersString) else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        return urlRequest
    }
}
