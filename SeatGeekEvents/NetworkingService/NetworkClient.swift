//
//  NetworkClient.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    func performRequest<T: Decodable>(route: NetworkRouter, session: URLSession, decoder: JSONDecoder, completion: @escaping (T?, Error?) -> Void)
}

class NetworkClient: NetworkClientProtocol {

    func performRequest<T: Decodable>(route: NetworkRouter, session: URLSession, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (T?, Error?) -> Void)  {

        do {
            let request = try route.asURLRequest()
            session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, NetworkError.noDataAvailable)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    200...299 ~= response.statusCode else {
                        if let badStatusCodeError = try? JSONDecoder().decode(BadStatusCodeError.self, from: data) {
                            completion(nil, badStatusCodeError)
                            return
                        }
                        completion(nil, NetworkError.invalidResponse)
                        return
                }
                guard let result = try? decoder.decode(T.self, from: data) else {
                    completion(nil, ParserError.cannotDecodeData)
                    return
                }
                completion(result, nil)
            }.resume()
        } catch {
            completion(nil, error)
        }
       
    }
}

