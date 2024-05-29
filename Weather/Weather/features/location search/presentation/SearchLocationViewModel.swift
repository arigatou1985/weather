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
    @Published private(set) var localizedError: String?
    
    init(
        searchLocationUseCase: SearchLocationUseCase,
        onLocationSelected: ((SearchedLocation) -> ())? = nil
    ) {
        self.searchLocationUseCase = searchLocationUseCase
        self.onLocationSelected = onLocationSelected
        subscribeToPublishers()
    }

    let emptyViewMessage = "Type something to search for the location you're interested in."
    
    private func subscribeToPublishers() {
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { term in
                self.performSearch(term: term)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(term: String) {
        guard !self.searchTerm.isEmpty else {
            self.locations = []
            self.isShowingEmptyView = true
            return
        }
        
        Task { [weak self] in
            guard let self else { return }
            do {
                let locations = try await self.searchLocationUseCase.searchLocations(matching: term)
                self.locations = locations
                self.isShowingEmptyView = locations.isEmpty
                localizedError = nil
            } catch (let error) {
                print("error\(error)")
                localizedError = error.localizedDescription
            }
        }
    }
    
    func didSelect(location: SearchedLocation) {
        onLocationSelected?(location)
    }
    
    private let searchLocationUseCase: SearchLocationUseCase
    private var cancellables = Set<AnyCancellable>()
    private let onLocationSelected: ((SearchedLocation) -> ())?
}
