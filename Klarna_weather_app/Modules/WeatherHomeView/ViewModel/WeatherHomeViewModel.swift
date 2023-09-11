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
    @Published var weatherData: WeatherData = WeatherData()
    @Published var showError: Bool = false
    @Published var error: Error? {
        
        didSet {
            
            self.showError = (error != nil)
            setLocationSearchError()
        }
    }

    private let weatherService: AnyWeatherService
    private let locationProvider: LocationProvider
    var locationSearchViewModel: AnySearchViewModel<LocationResponse>
    private var cancellables: Set<AnyCancellable> = []

    init(weatherService: AnyWeatherService = WeatherService(),
         locationProvider: LocationProvider = LocationProvider()) {
        
        self.weatherService = weatherService
        self.locationProvider = locationProvider
        self.locationSearchViewModel = AnySearchViewModel(onSearchTermChange: { _ in }, onResultSelection: { _ in })
        
        setupLocationSearchViewModel()
        setupLocationProvider()
        loadWeatherForCurrentLocation()
    }
    
    // MARK: - Public helper functions

    func changeUnit() {
        
        self.weatherData.changeUnit()
    }

    func showLocationSearch() {
        
        shouldShowLocationSearch = true
    }

    func loadWeatherForCurrentLocation() {
        
        locationProvider.startLocationServices()
    }
    
    // MARK: - Private helper functions

    /// Sets up the `locationProvider`.
    
    private func setupLocationProvider() {
        
        locationProvider.$currentLocation
                    .compactMap { $0 } // Remove nil values
                    .sink(receiveValue: { [weak self] newLocation in
                        
                        self?.weatherData.city = newLocation
                        self?.fetchWeather()
                    })
                    .store(in: &cancellables)
    }

    /// Sets up the `locationSearchViewModel`.
    
    private func setupLocationSearchViewModel() {
        
        locationSearchViewModel.onSearchTermChange = { [weak self] location in
            
            self?.searchLocations(searchTerm: location)
        }

        locationSearchViewModel.onResultSelection = { [weak self] location in
            
            self?.weatherData.city = location
            self?.fetchWeather()
            self?.shouldShowLocationSearch = false
        }
    }

    private func searchLocations(searchTerm: String) {
        
        weatherService.fetchLocations(for: searchTerm)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                if case .failure(let error) = completion {
                    
                    self?.error = error
                }
            }, receiveValue: { [weak self] locations in
                
                self?.locationSearchViewModel.results = locations
            })
            .store(in: &cancellables)
    }

    private func fetchWeather() {
        
        guard let city = self.weatherData.city else { return }
        
        weatherService.fetchTemperature(latitude: city.lat, longitude: city.lon)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    
                    self?.error = error
                }
            }, receiveValue: { [weak self] temperatureMeasurement in
                
                self?.weatherData.setTemperature(temp: temperatureMeasurement)
            })
            .store(in: &cancellables)
    }

    private func setLocationSearchError() {
        
        if shouldShowLocationSearch {
            
            locationSearchViewModel.error = error
        }
    }
}

