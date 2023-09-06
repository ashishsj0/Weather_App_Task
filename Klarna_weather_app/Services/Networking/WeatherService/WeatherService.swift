//
//  WeatherService.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation
import Combine

class WeatherService {
    
    private let networkLayer: Networkable
    private var apiKey: String { "" }
    // this should be somewhere safe, not in source code, but bear with it for now. :)
    
    init(networkLayer: Networkable = BaseNetworkLayer()) {
        
        self.networkLayer = networkLayer
    }
    
    func fetchTemperature(latitude: Double, longitude: Double) -> AnyPublisher<Measurement<UnitTemperature>, Error> {
        
        return performRequest(for: .weather(lat: latitude, lon: longitude))
            .tryMap { (response: WeatherResponse) in
                
                return response.temperatureMeasurement
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchLocations(for city: String) -> AnyPublisher<[LocationResponse], Error> {
        
        return performRequest(for: .geocoding(city: city, limit: 5))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func performRequest<T: Decodable>(for apiPath: APIPath) -> AnyPublisher<T, Error> {
        
        guard let url = constructURL(for: apiPath) else {
            
            return Fail(error: NetworkError.badURL)
                .eraseToAnyPublisher()
        }
        
        return networkLayer.performRequest(for: url)
            .catch { error -> AnyPublisher<T, Error> in
                
                return Fail(error: NetworkError.other(error))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func constructURL(for apiPath: APIPath) -> URL? {
        
        if let url = APIConstants.baseURL {
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.path = apiPath.path
            components?.queryItems = apiPath.queryItems
            components?.queryItems?.append(URLQueryItem(name: "appid", value: apiKey))
            
            return components?.url
        }
        
        return nil
    }
}
