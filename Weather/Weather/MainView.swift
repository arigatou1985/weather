//
//  MainView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@MainActor
struct MainView: View {
    var body: some View {
        let weatherDetailsViewModel = WeatherDetailsViewModel(
            fetchWeatherAtCurrentLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherAtCurrentLocationUseCase(),
            fetchWeatherAtSelectedLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherUseCase()
        )
            
        let searchLocationViewModel = SearchLocationViewModel(
            searchLocationUseCase: SearchLocationViewUseCaseFactory.searchLocationUseCase()) { location in
                weatherDetailsViewModel.userSelectedLocation = WeatherDetailsLocation(with: location)
            }
        
        WeatherDetailsView()
            .environmentObject(weatherDetailsViewModel)
            .environmentObject(searchLocationViewModel)
    }
}

#Preview {
    let fetchWeatherAtCurrentLocationUseCase = FetchWeatherAtCurrentLocationUseCase(
        locationProvider: LocationProviderForPreview(),
        weatherRepository: WeatherRepositoryForPreview()
    )
    
    let fetchWeatherAtSelectedLocationUseCase = FetchWeatherUseCase(
        weatherRepository: WeatherRepositoryForPreview()
    )
    
    @State var viewModel = WeatherDetailsViewModel(
        fetchWeatherAtCurrentLocationUseCase: fetchWeatherAtCurrentLocationUseCase,
        fetchWeatherAtSelectedLocationUseCase: fetchWeatherAtSelectedLocationUseCase
    )

    @State var searchLocationViewModel = SearchLocationViewModel(
        searchLocationUseCase: SearchLocationUseCase(locationRepository: LocationRepositoryForPreview())
    )
    
    return MainView()
}

private extension WeatherDetailsLocation {
    init(with location: LocationSearchDomain.Location) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.name = location.name
    }
}
