//
//  Klarna_weather_appApp.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import SwiftUI

@main
struct Klarna_weather_appApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView()
                .onChange(of: scenePhase) { phase in
                    
                    if phase == .background {
                        
                        LocationManager.shared.stopLocationServices()
                    }
                }
        }
    }
}
