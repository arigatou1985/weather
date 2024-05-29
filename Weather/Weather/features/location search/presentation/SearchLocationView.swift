//
//  SearchLocationView.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import SwiftUI

@MainActor
struct SearchLocationView: View {
    @EnvironmentObject var viewModel: SearchLocationViewModel
    @Environment(\.dismiss) var dismiss
    
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
                    HStack {
                        Text(location.name)
                        Spacer()
                        Button(action: {
                            viewModel.didSelect(location: location)
                            dismiss()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40.0)
                    .contentShape(Rectangle())
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
    @State var location: LocationSearchDomain.Location? = nil
    @StateObject var viewModel = SearchLocationViewModel(
        searchLocationUseCase: SearchLocationUseCase(locationRepository: LocationRepositoryForPreview())
    )
    
    return SearchLocationView()
        .environmentObject(viewModel)
}

extension LocationSearchDomain.Location: Identifiable {
    var id: String {
        "\(name.hashValue.description)\(latitude)\(longitude)"
    }
}
