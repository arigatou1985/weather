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
            VStack {
                locationList
                    .navigationTitle("Search Location")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $viewModel.searchTerm)
                Spacer()
                errorMessage
            }
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
        Text(viewModel.emptyViewMessage)
            .padding()
            .foregroundStyle(.gray)
    }
    
    @ViewBuilder
    private var errorMessage: some View {
        if let localizedError = viewModel.localizedError {
            VStack {
                Spacer()
                Text(localizedError)
                    .foregroundStyle(.red)
            }
        } else {
            EmptyView()
        }
    }
    
}

#Preview {
    return SearchLocationView()
        .environmentObject(PreviewViewModelFactory.searchLocationViewModel())
}

extension SearchedLocation: Identifiable {
    var id: String {
        "\(name.hashValue.description)\(latitude)\(longitude)"
    }
}
