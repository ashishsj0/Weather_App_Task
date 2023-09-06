//
//  AnySearchViewModel.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation

protocol AnySearchSelectable: Identifiable {
    
    var displayName: String { get }
}

class AnySearchViewModel<T: AnySearchSelectable>: ObservableObject {
    
    @Published var searchText: String = "" {
        
        didSet {
            
            search()
        }
    }
    
    @Published var results: [T] = []
    @Published var showError: Bool = false
    
    var error: Error? {
        
        didSet {
            
            self.showError = (error != nil)
        }
    }
    
    let pageTitle: String = "Search"

    var onSearchTermChange: (String) -> Void
    var onResultSelection: (T) -> Void
    
    let searchTextMinimumThreshold: Int = 2

    init(onSearchTermChange: @escaping(String) -> Void, onResultSelection: @escaping(T) -> Void) {
        
        self.onSearchTermChange = onSearchTermChange
        self.onResultSelection = onResultSelection
    }

    func search() {
        
        if searchText.count >= searchTextMinimumThreshold {
            
            onSearchTermChange(searchText)
        }
    }
    
    func setError(err: Error?) {
        
        self.error = err
    }
}
