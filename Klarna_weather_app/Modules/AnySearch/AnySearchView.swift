//
//  CitySearchView.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import SwiftUI

struct AnySearchView<T: AnySearchSelectable>: View {
    
    @ObservedObject var viewModel: AnySearchViewModel<T>
        
    var body: some View {
                
            VStack(spacing: 16) {
                
                SearchBarView(searchText: $viewModel.searchText)
                    .padding(.top, 8)
                
                resultView
                
                Spacer()
            }
            .navigationBarTitle(viewModel.pageTitle , displayMode: .inline)
            .alert(isPresented: $viewModel.showError) {
                
                Alert(title: Text("Error"),
                      message: Text(viewModel.error?.localizedDescription ?? "Unknown error"),
                      dismissButton: .default(Text("Ok")))
            }
    }
    
    //MARK: Subviews
    
    @ViewBuilder private var emptyView: some View {
        
        VStack(spacing: 20) {
         
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .tint(.accentColor)
            
            Text("No results found.")
        }
    }
    
    @ViewBuilder private var searchResult: some View {
        
        List(viewModel.results) { item in
            
            Text(item.displayName)
                .padding(.all,4)
                .onTapGesture {
                    
                    viewModel.onResultSelection(item)
                }
        }
    }
    
    @ViewBuilder private var resultView: some View {
        
        if viewModel.results.isEmpty {
            
            emptyView
        } else {
            
            searchResult
        }
    }
}

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        
        HStack {
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search for location", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
            
            if !searchText.isEmpty {
                
                Button(action: {
                    
                    searchText = ""
                }) {
                    
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
        .padding(.horizontal)
    }
}
