//
//  LocationManager.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 06/09/23.
//

import Foundation
import CoreLocation
import UIKit

enum LocationError: Error {
    
    case denied
    case notAuthorized
    case generic
}

final class CoreLocationManager: NSObject, ObservableObject {
    
    static let shared = CoreLocationManager()
    
    private var locationManager: CLLocationManager
    
    @Published var currentLocation: LocationResponse?
    @Published var error: Error?
    
    private override init() {
        
        self.locationManager = CLLocationManager()
        super.init()
        setupLocationManager()
    }
    
    /// Configure the location manager.
    
    private func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Starts updating device location.
    ///
    /// This function checks the Location auth status and starts updating location if status is`.authorizedAlways, .authorizedWhenInUse`, requests access if `notDetermined`.

    func startLocationServices() {
        
        self.error = nil
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            self.error = LocationError.denied
            
        @unknown default:
            break
        }
    }
    
    /// Stops updating device location.
    
    func stopLocationServices() {
        
        self.locationManager.stopUpdatingLocation()
    }
}

//MARK: Location Manager Delegates

extension CoreLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch locationManager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.error = nil
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            self.error = LocationError.denied
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let latest = locations.first else { return }
        
        Task {
            
            if let response = await LocationResponse.from(location: latest) {
                
                currentLocation = response
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let clError = error as? CLError {
            
            switch clError.code {
             
            case .denied,.promptDeclined:
                self.error = error
                
            default: break
                
            }
        }
    }
}



