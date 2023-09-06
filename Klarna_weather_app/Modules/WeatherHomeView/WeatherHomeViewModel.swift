//
//  WeatherHomeViewModel.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation
import Combine

class WeatherHomeViewModel: ObservableObject {
    
    @Published var shouldShowLocationSearch: Bool = false
    @Published var unit: UnitTemperature
    @Published var city: LocationResponse?
    @Published var showError: Bool = false
    
    private let weatherService: WeatherService
    private let locationManager: LocationManager
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published private var searchResults: [LocationResponse] = [] {
        
        didSet {
            
            self.locationSearchViewModel.results = searchResults
        }
    }
    
    private var _temperature: Measurement<UnitTemperature>? {
        
        didSet {
            
            objectWillChange.send()
        }
    }
    
    var locationSearchViewModel: AnySearchViewModel<LocationResponse>
    
    var error: Error? {
        
        didSet {
            
            self.showError = (error != nil)
            self.setLocationSearchError()
        }
    }

    var temperature: String {
        
        guard let _temperature = _temperature else { return "NA" }
        let formattedTemp = _temperature.converted(to: unit).value
        return String(format: "%.1f %@", formattedTemp, unit.symbol)
    }
    
    init(weatherService: WeatherService = WeatherService(), locationManager: LocationManager = .shared) {
        
        self.unit = .kelvin
        self.city = nil
        self._temperature = nil
        self.weatherService = weatherService
        self.locationManager = locationManager
        locationManager.startLocationServices()
        
        self.locationSearchViewModel = AnySearchViewModel(onSearchTermChange: { _ in }, onResultSelection: { _ in })
        
        locationSearchViewModel.onSearchTermChange = { [weak self] location in
            
            guard let self = self else { return }
            
            self.searchLocations(searchTerm: location)
        }
        
        locationSearchViewModel.onResultSelection = { [weak self] location in
            
            guard let self = self else { return }
            
            self.city = location
            self.fetchWeather()
            self.shouldShowLocationSearch = false
        }
        
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak locationManager] newLocation in
                
                guard let self = self else { return }
                self.city = newLocation
                self.fetchWeather()
                locationManager?.stopLocationServices()
            }
            .store(in: &cancellables)
        
        locationManager.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                
                guard let self = self else { return }
                self.setError(err: error)
            }
            .store(in: &cancellables)
    }
    
    private func searchLocations(searchTerm: String) {
        
        weatherService.fetchLocations(for: searchTerm)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                    
                case .finished:
                    break
                case .failure(let error):
                    
                    self?.setError(err: error)
                }
            }, receiveValue: { [weak self] locations in
                
                self?.searchResults = locations
            })
            .store(in: &cancellables)
    }
    
    private func didSelectNewLocation(location: LocationResponse) {
        
        self.city = location
        self.fetchWeather()
    }
    
    private func fetchWeather() {
        
        let latitude = self.city?.lat ?? LocationResponse.notAvailable.lat
        let longitude = self.city?.lon ?? LocationResponse.notAvailable.lon
        
        weatherService.fetchTemperature(latitude: latitude,
                                        longitude: longitude)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            
            switch completion {
                
            case .finished:
                break
            case .failure(let error):
                
                self?.setError(err: error)
            }
        }, receiveValue: { [weak self] temperatureMeasurement in
            
            self?._temperature = temperatureMeasurement
        })
        .store(in: &cancellables)
    }
    
    private func setLocationSearchError() {
        
        if shouldShowLocationSearch {
            
            self.locationSearchViewModel.setError(err: error)
        }
    }
    
    func changeUnit() {
        
        switch unit {
            
        case .kelvin:
            unit = .celsius
            
        case .celsius:
            unit = .fahrenheit
            
        case .fahrenheit:
            unit = .kelvin
            
        default:
            unit = .kelvin
        }
    }
    
    func showLocationSearch() {
        
        self.shouldShowLocationSearch = true
    }
    
    func loadWeatherForCurrentLocation() {
        
        self.locationManager.startLocationServices()
    }
    
    func setError(err: Error?) {
        
        self.error = err
    }
}

