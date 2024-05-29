//
//  ViewModelForPreviewFactory.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-29.
//

import Foundation

@MainActor
class PreviewViewModelFactory {
    static func weatherDetailsViewModel() -> WeatherDetailsViewModel {
        WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase(),
            fetchWeatherAtSelectedLocationUseCase: fetchWeatherAtSelectedLocationUseCase(), 
            monitorSignificantCurrentUserLocationChangeUseCase: monitorSignificantCurrentUserLocationChangeUseCase()
        )
    }
    
    static func searchLocationViewModel() -> SearchLocationViewModel {
        SearchLocationViewModel(
            searchLocationUseCase: searchLocationUseCase()
        )
    }
    
    private static func monitorSignificantCurrentUserLocationChangeUseCase() -> MonitorSignificantLocationChangeUseCase {
        MonitorSignificantLocationChangeUseCase(locationMonitor: PreviewLocationMonitor())
    }
    
    private static func fetchWeatherAtCurrentLocationUseCase() -> FetchWeatherAtCurrentLocationUseCase {
        FetchWeatherAtCurrentLocationUseCase(
            locationProvider: previewLocationProvider(),
            weatherRepository: previewWeatherRepository()
        )
    }
    
    private static func fetchWeatherAtSelectedLocationUseCase() -> FetchWeatherUseCase {
        FetchWeatherUseCase(
            weatherRepository: previewWeatherRepository()
        )
    }
    
    private static func searchLocationUseCase() -> SearchLocationUseCase {
        SearchLocationUseCase(locationRepository: previewLocationRepository())
    }
    
    private static func previewLocationProvider() -> LocationProvider {
        PreviewLocationProvider()
    }
    
    private static func previewWeatherRepository() -> WeatherRepository {
        PreviewWeatherRepository()
    }
    
    private static func previewLocationRepository() -> LocationRepository {
        PreviewLocationRepository()
    }
}
