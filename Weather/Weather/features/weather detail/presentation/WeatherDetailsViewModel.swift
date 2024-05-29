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
    @Published var userSelectedLocation: Location?
    
    init(
        fetchWeatherAtCurrentLocationUseCase: FetchWeatherAtCurrentLocationUseCase,
        fetchWeatherAtSelectedLocationUseCase: FetchWeatherUseCase
    ) {
        self.fetchWeatherAtCurrentLocationUseCase = fetchWeatherAtCurrentLocationUseCase
        self.fetchWeatherAtSelectedLocationUseCase = fetchWeatherAtSelectedLocationUseCase
        
        subscribeToPublishers()
    }
    
    private func subscribeToPublishers() {
        $userSelectedLocation
            .dropFirst()
            .sink { [weak self] newLocation in
                print("new location selected: \(newLocation?.name ?? "Unknown location")")
                guard let self, let newLocation else { return }
                fetchWeather(
                    at: GeoCoordinates(
                        latitude: newLocation.latitude,
                        longitude: newLocation.longitude)
                )
            }
            .store(in: &cancellables)
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
