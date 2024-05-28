//
//  SearchLocationView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@MainActor
struct SearchLocationView: View {
    @StateObject var viewModel: SearchLocationViewModel
    
    var body: some View {
        NavigationStack {
            locationList
            .navigationTitle("Search Location")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchTerm)
        }
    }
    
    @ViewBuilder
    private var locationList: some View {
        if viewModel.isShowingEmptyView {
            emptyView
        } else {
            List {
                ForEach(viewModel.locations) { location in
                    Text(location.name)
                }
            }
        }
    }
    
    private var emptyView: some View {
        Rectangle()
            .foregroundColor(.green)
    }
    
}

#Preview {
    @StateObject var viewModel = SearchLocationViewModel(searchLocationUseCase: SearchLocationUseCase(locationRepository: LocationRepositoryForPreview()))
    return SearchLocationView(viewModel: viewModel)
}

extension Location: Identifiable {
    var id: String {
        "\(name.hashValue.description)\(latitude)\(longitude)"
    }
}
