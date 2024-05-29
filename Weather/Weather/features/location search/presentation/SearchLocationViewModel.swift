//
//  SearchLocationViewModel.swift
//  Weather
//
//  Created by Jing Yu on 2024-05-28.
//

import Foundation
import Combine

@MainActor
class SearchLocationViewModel: ObservableObject {
    @Published private(set) var locations = [SearchedLocation]()
    @Published private(set) var isShowingEmptyView = true
    @Published var searchTerm: String = ""
    
    init(
        searchLocationUseCase: SearchLocationUseCase,
        onLocationSelected: ((SearchedLocation) -> ())? = nil
    ) {
        self.searchLocationUseCase = searchLocationUseCase
        self.onLocationSelected = onLocationSelected
        subscribeToPublishers()
    }

    private func subscribeToPublishers() {
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { term in
                guard !self.searchTerm.isEmpty else {
                    self.locations = []
                    self.isShowingEmptyView = true
                    return
                }
                
                Task { [weak self] in
                    guard let self else { return }
                    let locations = try await self.searchLocationUseCase.searchLocations(matching: term)
                    self.locations = locations
                    self.isShowingEmptyView = locations.isEmpty
                }
            }
            .store(in: &cancellables)
    }
    
    func didSelect(location: SearchedLocation) {
        onLocationSelected?(location)
    }
    
    private let searchLocationUseCase: SearchLocationUseCase
    private var cancellables = Set<AnyCancellable>()
    private let onLocationSelected: ((SearchedLocation) -> ())?
}
