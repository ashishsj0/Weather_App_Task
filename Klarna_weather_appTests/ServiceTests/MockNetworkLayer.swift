//
//  MockNetworkLayer.swift
//  Klarna_weather_appTests
//
//  Created by ashish sharma on 06/09/23.
//

import Foundation
import Combine

@testable import Klarna_weather_app

class MockNetworkLayer: Networkable {
    
    var result: Result<Data, URLError>?
    
    func performRequest<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        guard let result = result else {
            fatalError("Did not set expected result for mock")
        }
        
        return Future<T, Error> { promise in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    promise(.success(decoded))
                } catch {
                    promise(.failure(error))
                }
            case .failure(let error):
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
