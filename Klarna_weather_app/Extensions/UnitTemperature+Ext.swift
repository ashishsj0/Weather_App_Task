//
//  UnitTemperature+Ext.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 11/09/23.
//

import Foundation

extension UnitTemperature {
    
    func next() -> UnitTemperature {
        
        switch self {
            
        case .kelvin:
            return .celsius
            
        case .celsius:
            return .fahrenheit
            
        case .fahrenheit:
            return .kelvin
            
        default:
            return .kelvin
        }
    }
}
