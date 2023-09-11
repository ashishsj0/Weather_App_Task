//
//  WeatherService.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation
import Combine

protocol WeatherServiceConfigurable {
    
    var networkLayer: Networkable { get set }
    var apiKey: String { get set }
}

protocol AnyWeatherService: WeatherServiceConfigurable {
    
    func fetchTemperature(latitude: Double, longitude: Double) -> AnyPublisher<Measurement<UnitTemperature>, Error>
    func fetchLocations(for city: String) -> AnyPublisher<[LocationResponse], Error>
}

class WeatherService: AnyWeatherService {
    
    internal var networkLayer: Networkable
    internal var apiKey: String
    
    // apiKey should be somewhere safe, not in source code, but bear with it for now. :)
    
    init(networkLayer: Networkable = BaseNetworkLayer(), apiKey: String = "") {
        
        self.networkLayer = networkLayer
        self.apiKey = apiKey
    }
    
    /// Fetches temperature for given `latitude` and `longitude`
    
    func fetchTemperature(latitude: Double, longitude: Double) -> AnyPublisher<Measurement<UnitTemperature>, Error> {
        
        return performRequest(for: .weather(lat: latitude, lon: longitude))
            .tryMap { (response: WeatherResponse) in
                
                return response.temperatureMeasurement
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Fetches location for a given `city`.
    
    func fetchLocations(for city: String) -> AnyPublisher<[LocationResponse], Error> {
        
        return performRequest(for: .geocoding(city: city, limit: 5))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension WeatherService {
    
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
