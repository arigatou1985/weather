//
//  FetchWeatherAtCurrentLocationUseCaseTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
import Combine
@testable import Weather

final class FetchWeatherAtCurrentLocationUseCaseTests: XCTestCase {

    @MainActor
    func testFetchWeatherShouldReturnWeatherIfNoErrorOccurred() async {
        let useCase = FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let latitude = 59.3293
        let longitude = 18.0686
        let name = "Stockholm"
        
        let expectedTemperature = 20.1
        let expectedTemperatureUnit: UnitTemperature = .celsius
        
        locationProvider.coordinates = GeoCoordinates(latitude: latitude, longitude: longitude)
        weatherProvider.weather = Weather(
            temperature: expectedTemperature,
            temperatureUnit: expectedTemperatureUnit,
            geoCoordinates: GeoCoordinates(latitude: latitude, longitude: longitude),
            locationName: name
        )
        
        do {
            let weather = try await useCase.fetchWeather()
            XCTAssertEqual(weather.temperature, expectedTemperature)
            XCTAssertEqual(weather.temperatureUnit, expectedTemperatureUnit)
            XCTAssertEqual(weather.geoCoordinates.latitude, latitude)
            XCTAssertEqual(weather.geoCoordinates.longitude, longitude)
            XCTAssertEqual(weather.locationName, name)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    @MainActor
    func testFetchWeatherShouldThrowErrorIfLocationProviderThrowsError() async {
        let useCase = FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let expectedError = LocationError.locationServiceDisabled
        locationProvider.error = expectedError
        
        do {
            _ = try await useCase.fetchWeather()
            XCTFail("Expected error to be thrown")
        } catch(let error) {
            XCTAssertEqual(error as? LocationError, expectedError)
        }
    }
    
    private let locationProvider = MockLocationProvider()
    private let weatherProvider = MockWeatherRepository()
}
