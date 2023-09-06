#Klarna Weather App

##Getting Started

###1. Adding the API Key

Before you start, you must obtain an API key from OpenWeatherMap. Once you have the key, add it to the project:

###Open the WeatherService.swift file.
Locate the apiKey computed property.
Replace the placeholder string with your actual API key.

private var apiKey: String { "YOUR_API_KEY_HERE" }

###2. Running the App
Ensure you have the latest version of Xcode installed. Open Klarna_weather_app.xcodeproj and run the app on the desired simulator or device.

##Features

 - Fetch and display the current weather based on the user's location or a selected city.
 - Fetch again by clicking on a button.
 - Switch between different temperature units (Kelvin, Celsius, and Fahrenheit) by clicking on the temprature text. 
 - Search functionality to look up weather by city.
 - Support for dark and light theme.


##Architecture & Implementation

 - The app utilizes the MVVM architecture.
 - It employs the Combine framework for reactive programming.
 - Networking is handled through a protocol-based approach for easy testing and mocking.
 - Error handling is present for both location services and network requests.

##Testing

Unit tests can be provided for critical components. Currently due to time constraints, it is only for one case to establish the fact that the code is testable. 

