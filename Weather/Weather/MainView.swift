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
        fetchWeatherAtCurrentLocationUseCase: WeatherDetailsViewUseCaseFactory.fetchWeatherAtCurrentLocationUseCase()
    )
    
    var body: some View {
        WeatherDetailsView(viewModel: weatherDetailsViewModel)
    }
}

#Preview {
    @State var useCase = FetchWeatherAtLocationUseCase(
        locationProvider: LocationProviderForPreview(),
        weatherRepository: WeatherRepositoryForPreview()
    )

    @State var weatherDetailsViewModel = WeatherDetailsViewModel(fetchWeatherAtCurrentLocationUseCase: useCase)

    return MainView(
        weatherDetailsViewModel: weatherDetailsViewModel)
}
