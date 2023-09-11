//
//  WeatherData.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 11/09/23.
//

import Foundation

struct WeatherData {
    
    var unit: UnitTemperature = .kelvin
    var city: LocationResponse? {
        
        didSet{
            
            print("here")
        }
    }

    private var _temperature: Measurement<UnitTemperature>?
    
    var temperature: String {
        
        guard let _temperature = _temperature else { return "NA" }
        let formattedTemp = _temperature.converted(to: unit).value
        return String(format: "%.1f %@", formattedTemp, unit.symbol)
    }
    
    mutating func changeUnit() {
        
        self.unit = unit.next()
    }
    
    mutating func setTemperature(temp: Measurement<UnitTemperature>) {
        
        self._temperature = temp
    }
}
