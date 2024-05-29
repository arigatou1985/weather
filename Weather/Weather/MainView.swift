//
//  MainView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@MainActor
struct MainView: View {
    @StateObject var weatherDetailsViewModel = WeatherDetailsViewModel(
        fetchWeatherAtCurrentLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherAtCurrentLocationUseCase(), 
        fetchWeatherAtSelectedLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherUseCase()
    )
    
    var body: some View {
        WeatherDetailsView(viewModel: weatherDetailsViewModel)
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

    return MainView(
        weatherDetailsViewModel: viewModel)
}
