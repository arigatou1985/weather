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
            fetchWeatherAtSelectedLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherUseCase(), 
            monitorSignificantCurrentUserLocationChangeUseCase: WeatherDetailsViewUseCaseFactory.monitorSignificantLocationChangeUseCase()
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
    return MainView()
}

private extension WeatherDetailsLocation {
    init(with location: SearchedLocation) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.name = location.name
    }
}
