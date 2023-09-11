//
//  WeatherView.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import SwiftUI
import Combine

struct WeatherHomeView: View {
    
    @ObservedObject private var viewModel = WeatherHomeViewModel()
    
    var body: some View {
            
            NavigationView {
                
                VStack(spacing: 16) {
                    
                    currentCityDetails
                        .foregroundColor(.primary)
                    
                    showSearchButton
                    
                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $viewModel.shouldShowLocationSearch, content: {
                
                AnySearchView(viewModel: viewModel.locationSearchViewModel)
            })
            .alert(isPresented: $viewModel.showError) {
                
                Alert(title: Text("Error"),
                      message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                      dismissButton: .default(Text("Ok")))
            }
    }
    
    //MARK: Subviews
    
    @ViewBuilder private var showSearchButton: some View {
        
        Button(action: {
            
            self.showSearch()
        }, label: {
            
            Text("Search for Location")
                .foregroundColor(.accentColor)
        })
    }
    
    @ViewBuilder private var currentCityDetails: some View {
        
        HStack {
            
            if let cityName = viewModel.weatherData.city?.name {
                
                Text(cityName)
            }
            
            Spacer()
            
            Button(action: {
                
                self.fetchCurrentLocationWeather()
            }, label: {
                
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.accentColor)
            })
        }
        
        HStack(spacing: 2) {
            
            Text(viewModel.weatherData.temperature)
                .bold()
                .onTapGesture {
                    
                    onUnitTap()
                }
        }
    }

    //MARK: methods
    
    private func onUnitTap() {
        
        viewModel.changeUnit()
    }
    
    private func showSearch() {
        
        viewModel.showLocationSearch()
    }
    
    private func fetchCurrentLocationWeather() {
        
        viewModel.loadWeatherForCurrentLocation()
    }
}
