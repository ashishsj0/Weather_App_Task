//
//  LocationResponse.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation
import CoreLocation

struct LocationResponse: Codable {
    
    var name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}

extension LocationResponse {
    
    static let notAvailable: LocationResponse = {
        
        LocationResponse(name: "NA", lat: 0.0, lon: 0.0, country: "", state: nil)
    }()
}

extension LocationResponse: AnySearchSelectable {
    
    var id: UUID {
        
        UUID()
    }
    
    var type: Codable {
        
        get {
            
            self
        }
    }
    
    var displayName: String {
        
        name
    }
}

extension LocationResponse {
    
    static func from(location: CLLocation) async -> LocationResponse? {
        
        let geocoder = CLGeocoder()
        
        do {
            
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let firstPlacemark = placemarks.first {
                
                let name = firstPlacemark.locality ?? "Unknown"
                let country = firstPlacemark.country ?? "Unknown"
                let state = firstPlacemark.administrativeArea
                
                return LocationResponse(name: name,
                                        lat: location.coordinate.latitude,
                                        lon: location.coordinate.longitude,
                                        country: country,
                                        state: state)
            } else {
                
                return nil
            }
        } catch {
            
            return nil
        }
    }
}

