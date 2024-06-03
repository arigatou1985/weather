//
//  WeatherDetailsViewModelTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
import Combine
import CoreLocation
@testable import Weather

final class WeatherDetailsViewModelTests: XCTestCase {
    @MainActor
    func testWeatherWillBeUpdatedWhenUserSelectsALocation() async {
        // Given
        let fetchWeatherAtCurrentLocationUseCase =  FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let monitorSignificantLocationChangeUseCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let viewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherUseCase,
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantLocationChangeUseCase
        )
        
        let latitude = 10.1
        let longitude = 20.1
        let name = "Stockholm"
        
        await weatherProvider.setWeather(
            Weather(
                temperature: 20.1,
                temperatureUnit: .celsius,
                geoCoordinates: GeoCoordinates(latitude: latitude, longitude: longitude),
                locationName: name
            )
        )
        
        let expectation = expectation(description: "Weather will be updated when user selects a location")
        
        viewModel.$weather
            .dropFirst()
            .sink { weather in
                XCTAssertEqual(weather?.temperature, 20.1)
                XCTAssertEqual(weather?.temperatureUnit, .celsius)
                XCTAssertEqual(weather?.geoCoordinates.latitude, latitude)
                XCTAssertEqual(weather?.geoCoordinates.longitude, longitude)
                XCTAssertEqual(weather?.locationName, "Stockholm")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.userSelectedLocation = WeatherDetailsLocation(
            latitude: 10.2,
            longitude: 20.3,
            name: "Stockholm"
        )
        
        // Then
        await fulfillment(of: [expectation], timeout: 0.2)
    }
    
    @MainActor
    func testLocalizedErrorWillBeUpdatedWhenCurrentLocationCannotBeFetched() async {
        let fetchWeatherAtCurrentLocationUseCase =  FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let monitorSignificantLocationChangeUseCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let viewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherUseCase,
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantLocationChangeUseCase
        )
        
        let expectation = expectation(description: "Localized error will be updated when current location cannot be fetched")
        
        let expectedError = LocationError.locationServiceDisabled
        
        viewModel.$localizedError
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Location service is disabled. Cannot get local weather data.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await locationProvider.setError(expectedError)
        
        viewModel.fetchWeatherAtCurrentLocation()
        
        await fulfillment(of: [expectation], timeout: 0.2)
    }
    
    @MainActor
    func testLocalizedErrorWillbeNullifiedWhenWeatherIsFetchedSuccessfully() async {
        let fetchWeatherAtCurrentLocationUseCase =  FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let monitorSignificantLocationChangeUseCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let viewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherUseCase,
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantLocationChangeUseCase
        )
        
        let expectationForError = expectation(description: "Localized error will be set when weather fetch failed")
        
        let expectedError = LocationError.locationServiceDisabled
        
        viewModel.$localizedError
            .dropFirst()
            .first()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectationForError.fulfill()
            }
            .store(in: &cancellables)
        
        await locationProvider.setError(expectedError)
        
        viewModel.fetchWeatherAtCurrentLocation()
        
        await fulfillment(of: [expectationForError], timeout: 0.2)
        
        let expectationForSuccess = expectation(description: "Localized error will be nullified when weather is fetched successfully")
        
        await weatherProvider.setWeather(
            Weather(
                temperature: 20.1,
                temperatureUnit: .celsius,
                geoCoordinates: GeoCoordinates(latitude: 10.2, longitude: 20.3),
                locationName: "Stockholm"
            )
        )
        
        await locationProvider.setError(nil)
        
        viewModel.$localizedError
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNil(errorMessage)
                expectationForSuccess.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeatherAtCurrentLocation()
        
        await fulfillment(of: [expectationForSuccess], timeout: 0.2)
    }
    
    @MainActor
    func testFetchWeatherForNewLocationWhenSignificantLocationChangeIsDetected() async {
        
        let fetchWeatherAtCurrentLocationUseCase =  FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let monitorSignificantLocationChangeUseCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let viewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherUseCase,
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantLocationChangeUseCase
        )
        
        await viewModel.startMonitoringLocationChange()
        let startLocation = CLLocation(latitude: 10.2, longitude: 20.1)
        await locationMonitor.setLocation(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
        
        let latitude = 10.1
        let longitude = 20.1
        let name = "Stockholm"
        
        await weatherProvider.setWeather(
            Weather(
                temperature: 20.1,
                temperatureUnit: .celsius,
                geoCoordinates: GeoCoordinates(latitude: latitude, longitude: longitude),
                locationName: name
            )
        )
                
        let expectation = expectation(description: "Weather will be updated when significant location change is detected")
        
        viewModel.$weather
            .dropFirst() // first weather is alway nil as initialized in the view model
            .first() // prevent multiple published changes that can lead to multiple calls to `expection.fulfill()` which is API violation
            .sink { weather in
                XCTAssertEqual(weather?.temperature, 20.1)
                XCTAssertEqual(weather?.temperatureUnit, .celsius)
                XCTAssertEqual(weather?.geoCoordinates.latitude, latitude)
                XCTAssertEqual(weather?.geoCoordinates.longitude, longitude)
                XCTAssertEqual(weather?.locationName, "Stockholm")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await locationMonitor.setLocation(latitude: 10.6, longitude: 21.3)
        
        await fulfillment(of: [expectation], timeout: 0.2)
    }
    
    @MainActor
    func testUserSelectedLocationNameShouldBeSetAccordingToTheUseSelectedLocation() async {
        let fetchWeatherAtCurrentLocationUseCase =  FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let monitorSignificantLocationChangeUseCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let viewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherUseCase,
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantLocationChangeUseCase
        )
        
        let expectedName = "Stockholm"
        let location = WeatherDetailsLocation(latitude: 10.1, longitude: 20.1, name: expectedName)
        
        viewModel.userSelectedLocation = location
        
        XCTAssertEqual(viewModel.userSelectedLocationName, expectedName)
        
        viewModel.userSelectedLocation = nil
        XCTAssertEqual(viewModel.userSelectedLocationName, "")
    }
    
    @MainActor
    func testWeatherLocationNameAndTemperatureInfoShouldBeSetAccordingToTheWeatherIfWeatherCanBeFetched() async {
        let fetchWeatherAtCurrentLocationUseCase =  FetchWeatherAtCurrentLocationUseCase(
            locationProvider: locationProvider,
            weatherRepository: weatherProvider
        )
        
        let fetchWeatherUseCase = FetchWeatherUseCase(weatherRepository: weatherProvider)
        
        let monitorSignificantLocationChangeUseCase = MonitorSignificantLocationChangeUseCase(locationMonitor: locationMonitor)
        
        let viewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherUseCase,
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantLocationChangeUseCase
        )
        
        // Initial condition, no weather is fetched yet
        XCTAssertEqual(viewModel.weatherLocationName, "")
        XCTAssertEqual(viewModel.temperatureInfo, "")
        
        // Given
        let expectedName = "London"
        let coordinates = GeoCoordinates(latitude: 10.1, longitude: 20.1)
        
        let weather = Weather(
            temperature: 20.1,
            temperatureUnit: .celsius,
            geoCoordinates: coordinates,
            locationName: expectedName
        )
        
        let location = WeatherDetailsLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            name: expectedName
        )
        
        await weatherProvider.setWeather(weather)
        
        let expectation = expectation(description: "Weather location name and temperature info will be set according to the weather")
        
        viewModel.$weather
            .dropFirst()
            .sink { weather in
                XCTAssertEqual(weather?.locationName, expectedName)
                XCTAssertEqual(viewModel.weatherLocationName, "Weather at \(expectedName)")
                XCTAssertEqual(viewModel.temperatureInfo, "Temperature: 20°C / 68°F")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.userSelectedLocation = location
        
        // Then
        await fulfillment(of: [expectation], timeout: 0.2)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let locationProvider = MockLocationProvider()
    private let weatherProvider = MockWeatherRepository()
    private let locationMonitor = MockLocationMonitor()
}
