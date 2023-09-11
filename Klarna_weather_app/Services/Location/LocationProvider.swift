//
//  LocationProvider.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 11/09/23.
//

import Foundation
import Combine

class LocationProvider: ObservableObject {
    
    @Published var currentLocation: LocationResponse? {
        
        didSet {
                
            self.stopLocationService()
        }
    }
    
    @Published var error: Error?

    private let locationManager: LocationManager
    private var cancellables: Set<AnyCancellable> = []

    init(locationManager: LocationManager = .shared) {
        
        self.locationManager = locationManager
        observeLocationManager()
    }

    func startLocationServices() {
        
        locationManager.startLocationServices()
    }
    
    func stopLocationService() {
        
        locationManager.stopLocationServices()
    }

    private func observeLocationManager() {
        
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentLocation, on: self)
            .store(in: &cancellables)

        locationManager.$error
            .receive(on: DispatchQueue.main)
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
}
