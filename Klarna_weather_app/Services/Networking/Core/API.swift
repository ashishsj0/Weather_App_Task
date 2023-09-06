//
//  API.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation

final class APIConstants {
    
    static var baseURL: URL? {
        
        URL.init(string: devURL)
    }
    
    private static let devURL = "https://api.openweathermap.org"
}

enum APIPath {
    
    case weather(lat: Double, lon: Double)
    case geocoding(city: String, limit: Int)
    
    var path: String {
        
        switch self {
            
        case .weather:
            return "/data/2.5/weather"
        case .geocoding:
            return "/geo/1.0/direct"
        }
    }
    
    var queryItems: [URLQueryItem] {
        
        switch self {
            
        case .weather(let lat, let lon):
            
            return [URLQueryItem(name: "lat", value: "\(lat)"),
                    URLQueryItem(name: "lon", value: "\(lon)")]
            
        case .geocoding(let city, let limit):
            
            return [URLQueryItem(name: "q", value: city),
                    URLQueryItem(name: "limit", value: "\(limit)")]
        }
    }
}

