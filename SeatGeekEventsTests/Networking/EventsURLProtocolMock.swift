//
//  EventsURLProtocolMock.swift
//  SeatGeekEventsTests
//
//  Created by Анастасия Ковалева on 3/25/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

private enum Constant {
    static let requiredParameter = "client_id"
    static let requiredParameterValue = "MjExNDE1MjN8MTU4NTAwNTQ2My44OA"
}

class EventsURLProtocolMock: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: NetworkError.invalidURL)
            return
        }
        let requiredQuery = "\(Constant.requiredParameter)=\(Constant.requiredParameterValue)"

        if let query = url.query, query.contains(requiredQuery) {
            client?.urlProtocol(self, didLoad: Data())
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: request.allHTTPHeaderFields)
            client?.urlProtocol(self,
                                didReceive: response!,
                                cacheStoragePolicy: .allowedInMemoryOnly)
        } else {
            let badStatusCodeError = BadStatusCodeError(message: "Client info is required")
            if let badStatusCodeData = try? JSONEncoder().encode(badStatusCodeError) {
                client?.urlProtocol(self, didLoad: badStatusCodeData)
            }
            let response = HTTPURLResponse(url: url,
                                          statusCode: 403,
                                          httpVersion: nil,
                                          headerFields: request.allHTTPHeaderFields)
            client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
