//
//  OpenWeatherAPI.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

@preconcurrency import Foundation

actor OpenWeatherAPI {
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    /// Get the weather data at a specific location
    /// - Reference: https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
    func fetchWeatherData(at latitude: Double, longitude: Double) async throws -> WeatherResponse {
        print("Fetching weather from openweather api for (\(latitude), \(longitude))")
        let url = URL(string: "\(apiEntryPoint)/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)")!
        let (data, _) = try await urlSession.data(from: url)
        let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weather
    }
    
    // http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
   func fetchLocationsData(matching term: String) async throws -> [LocationResponse] {
       let url = URL(string: "\(apiEntryPoint)/geo/1.0/direct?q=\(term)&limit=5&appid=\(apiKey)")!
       let (data, _) = try await urlSession.data(from: url)
       let locations = try JSONDecoder().decode([LocationResponse].self, from: data)
       return locations
   }
    
    private let apiEntryPoint = "https://api.openweathermap.org"
    private let apiKey = "bd3c0de58ab04d50db729292ba5032a0"
    private let urlSession: URLSession
}
