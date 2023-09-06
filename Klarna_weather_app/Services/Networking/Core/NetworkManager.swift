//
//  NetworkManager.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation
import Combine


protocol Networkable {
    
    func performRequest<T: Decodable>(for url: URL) -> AnyPublisher<T, Error>
}

class BaseNetworkLayer: Networkable {
    
    func performRequest<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
