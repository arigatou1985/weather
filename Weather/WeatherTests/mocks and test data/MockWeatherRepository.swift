//
//  MockWeatherRepository.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation
@testable import Weather

final class MockWeatherRepository: WeatherRepository {

    func fetchWeather(at latitude: Double, longitude: Double) async throws -> Weather {
        if error != nil {
            throw error!
        }
        
        return weather
    }
    
    var weather = Weather(
        temperature: 20.1,
        temperatureUnit: .celsius,
        geoCoordinates: GeoCoordinates(latitude: 10.2, longitude: 20.3),
        locationName: "Stockholm"
    )
    
    var error: Error?
}
