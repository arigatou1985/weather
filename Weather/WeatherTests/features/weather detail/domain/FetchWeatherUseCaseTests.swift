//
//  FetchWeatherUseCaseTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
import Combine
@testable import Weather

final class FetchWeatherUseCaseTests: XCTestCase {
    
    func testFetchWeather() async {
        let latitude = 37.7749
        let longitude = -122.4194
        let locationCoordinates = GeoCoordinates(latitude: latitude, longitude: longitude)
        let locationName = "San Francisco"
        let expectedTemperature = 20.0
        let expectedTemperatureUnit: UnitTemperature = .celsius
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        await weatherProvider.setWeather(
            Weather(
                temperature: expectedTemperature,
                temperatureUnit: expectedTemperatureUnit,
                geoCoordinates: locationCoordinates,
                locationName: locationName
            )
        )
        
        do {
            let weather = try await fetchWeatherUseCase.fetchWeather(at: locationCoordinates)
            XCTAssertEqual(weather.temperature, expectedTemperature)
            XCTAssertEqual(weather.temperatureUnit, expectedTemperatureUnit)
            XCTAssertEqual(weather.geoCoordinates.latitude, latitude)
            XCTAssertEqual(weather.geoCoordinates.longitude, longitude)
            XCTAssertEqual(weather.locationName, locationName)
        } catch {
            XCTFail("Failed to fetch weather")
        }
    }
    
    func testFetchWeatherShouldThrowErrorIfWeatherRepositoryThrowsError() async {
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let expectedError = NSError(domain: "api error", code: 500)
        
        await weatherProvider.setError(expectedError as Error)
        
        do {
            _ = try await fetchWeatherUseCase.fetchWeather(at: GeoCoordinates(latitude: 0, longitude: 0))
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as NSError, expectedError)
        }
    }
    
    private let weatherProvider = MockWeatherRepository()
}
