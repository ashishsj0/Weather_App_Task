//
//  WeatherResponse.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation

struct WeatherResponse: Codable {
    
    let main: Main
    
    var temperatureMeasurement: Measurement<UnitTemperature> {
        
        Measurement(value: main.temp, unit: UnitTemperature.kelvin)
        
        // the API returns Kelvin by default and doesn't contain any key for unit.
    }
}

struct Main: Codable {
    
    let temp: Double
}
