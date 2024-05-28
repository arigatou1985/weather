//
//  WeatherResponse.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation

/// - Payload from the open weather API for https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
/// - Reference: https://openweathermap.org/current#data
// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let name: String

    // MARK: - Coord
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    // MARK: - Main
    struct Main: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        let seaLevel: Int?
        let grndLevel: Int?

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
