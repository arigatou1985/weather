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
    @Published private(set) var locations = [Location]()
    @Published private(set) var isShowingEmptyView = true
    @Published var searchTerm: String = ""

    init(searchLocationUseCase: SearchLocationUseCase) {
        self.searchLocationUseCase = searchLocationUseCase
        subscribeToPublishers()
    }

    private func subscribeToPublishers() {
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self else { return }
                
                Task {
                    let locations = try await self.searchLocationUseCase.searchLocations(matching: term)
                    self.locations = locations
                    self.isShowingEmptyView = locations.isEmpty
                }
            }
            .store(in: &cancellables)
    }
    
    private let searchLocationUseCase: SearchLocationUseCase
    private var cancellables = Set<AnyCancellable>()
}
