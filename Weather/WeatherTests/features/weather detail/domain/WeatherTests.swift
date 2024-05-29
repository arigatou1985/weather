//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {

    func testLocalizeTemperatureInCelcius() {
        let weather = Weather(
            temperature: 20,
            temperatureUnit: .celsius,
            geoCoordinates: GeoCoordinates(latitude: 49.2827, longitude: -123.1207),
            locationName: "Vancouver"
        )
        
        XCTAssertEqual(weather.localizeTemperatureInCelcius, "20°C")
    }
    
    func testLocalizeTemperatureInFahrenheit() {
        let weather = Weather(
            temperature: 20,
            temperatureUnit: .celsius,
            geoCoordinates: GeoCoordinates(latitude: 49.2827, longitude: -123.1207),
            locationName: "Vancouver"
        )
        
        XCTAssertEqual(weather.localizeTemperatureInFahrenheit, "68°F")
    }
}
