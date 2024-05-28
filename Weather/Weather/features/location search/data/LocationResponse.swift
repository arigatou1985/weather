//
//  LocationResponse.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

/// - Payload from the open weather API for http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
/// - Reference: https://openweathermap.org/api/geocoding-api
// MARK: - LocationResponse
struct LocationResponse: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
