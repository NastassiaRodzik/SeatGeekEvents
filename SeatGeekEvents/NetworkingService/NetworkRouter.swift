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
    var parameters: [String: String?] { get }
}

extension NetworkRouter {

    func asURLRequest() throws -> URLRequest {

        guard var urlComponents = URLComponents(string: urlString + path) else {
            throw NetworkError.invalidURL
        }
        let queryItems: [URLQueryItem] = parameters.map({ URLQueryItem(name: $0.key, value: $0.value) })
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        return urlRequest
    }
}
