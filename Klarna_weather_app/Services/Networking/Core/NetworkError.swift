//
//  NetworkError.swift
//  Klarna_weather_app
//
//  Created by ashish sharma on 05/09/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL provided was invalid."
        case .other(let error):
            return error.localizedDescription
        }
    }
}
