//
//  WeatherDetailsViewModel.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation
import Combine

@MainActor
class WeatherDetailsViewModel: ObservableObject {
    @Published private(set) var weather: Weather?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var localizedError: String?
    @Published var isPresentingSearchView = false
    @Published var userSelectedLocation: WeatherDetailsLocation?
    @Published private(set) var userSelectedLocationName: String = ""
    @Published private(set) var weatherLocationName: String = ""
    @Published private(set) var temperatureInfo: String = ""
    
    init(
        fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtCurrentLocationUseCase,
        fetchWeatherAtSelectedLocationUseCase: FetchWeatherUseCase,
        monitorSignificantCurrentUserLocationChangeUseCase:  MonitorSignificantLocationChangeUseCase
    ) {
        self.fetchWeatherAtCurrentLocationUseCase = fetchWeatherAtCurrentLocationUseCase
        self.fetchWeatherAtSelectedLocationUseCase = fetchWeatherAtSelectedLocationUseCase
        self.monitorSignificantCurrentUserLocationChangeUseCase = monitorSignificantCurrentUserLocationChangeUseCase
        subscribeToPublishers()
    }
    
    private func subscribeToPublishers() {
        $userSelectedLocation
            .dropFirst()
            .sink { [weak self] newLocation in
                print("new location selected: \(newLocation?.name ?? "Unknown location")")
                guard let self else { return }
                guard let newLocation else {
                    userSelectedLocationName = ""
                    return
                }
                fetchWeather(
                    at: GeoCoordinates(
                        latitude: newLocation.latitude,
                        longitude: newLocation.longitude)
                )
                
                userSelectedLocationName = newLocation.name
            }
            .store(in: &cancellables)
        
        $weather
            .dropFirst()
            .sink { [weak self] weather in
                guard let self, let weather = weather else { return }
                weatherLocationName = "Weather at \(weather.locationName ?? "Unknown location")"
                temperatureInfo = "Temperature: \(weather.localizeTemperatureInCelcius) / \(weather.localizeTemperatureInFahrenheit)"
            }
            .store(in: &cancellables)
    }
    
    func startMonitoringLocationChange() async {
        await withCheckedContinuation { continuation in
            Task { [weak self] in
                await self?.monitorSignificantCurrentUserLocationChangeUseCase.startMonitoring { [weak self] latitude, longitude in
                    guard let self else { return }
                    
                    Task {
                        let userSelectedLocation = await self.userSelectedLocation
                        guard userSelectedLocation == nil else { return }
                        await self.fetchWeather(at: GeoCoordinates(latitude: latitude, longitude: longitude))
                    }
                }
                
                continuation.resume(returning: ())
            }
        }
    }
    
    func fetchWeatherAtCurrentLocation() {
        fetch {
            self.weather = try await self.fetchWeatherAtCurrentLocationUseCase.fetchWeather()
        }
    }
    
    private func fetchWeather(at locationCoordinates: GeoCoordinates) {
        fetch {
            self.weather = try await self.fetchWeatherAtSelectedLocationUseCase.fetchWeather(at: locationCoordinates)
        }
    }
    
    private func fetch(doFetch: @escaping () async throws -> ()) {
        Task {
            isLoading = true
            do {
                try await doFetch()
                localizedError = nil
            } catch {
                print("Error fetching weather: \(error)")
                updateLocalizedError(with: error)
            }
            isLoading = false
        }
    }
    
    private func updateLocalizedError(with error: Error) {
        switch error {
        case LocationError.locationServiceDisabled:
            localizedError = "Location service is disabled. Cannot get local weather data."
        case LocationError.locationUpdateNotAvailable:
            localizedError = "Location update not available."
        default:
            localizedError = error.localizedDescription
        }
    }
    
    private let fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtCurrentLocationUseCase
    private let fetchWeatherAtSelectedLocationUseCase: FetchWeatherUseCase
    private let monitorSignificantCurrentUserLocationChangeUseCase:  MonitorSignificantLocationChangeUseCase
    private var cancellables = Set<AnyCancellable>()
}

extension Weather {
    var localizeTemperatureInCelcius: String {
        NumberFormatter.formatTemperature(temperature, fromUnit: .celsius, toUnit: .celsius)
    }
    
    var localizeTemperatureInFahrenheit: String {
        NumberFormatter.formatTemperature(temperature, fromUnit: .celsius, toUnit: .fahrenheit)
    }
}
