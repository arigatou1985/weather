//
//  SearchLocationViewModelTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
import Combine
@testable import Weather

final class SearchLocationViewModelTests: XCTestCase {
    
    @MainActor 
    func testSearchTermChangeShouldTriggerSearchAndReturnMatchingLocations() async {
        let useCase = SearchLocationUseCase(locationRepository: locationRepository)
        
        let viewModel = SearchLocationViewModel(
            searchLocationUseCase: useCase,
            onLocationSelected: { _ in }
        )
        
        XCTAssertTrue(viewModel.locations.isEmpty)
        
        let allLocations = locationRepository.sampleLocations
        let expectedLocations = allLocations.filter { $0.name.contains("Vancouver") }
        
        await locationRepository.setLocation(allLocations)
        
        let expectation = expectation(description: "Search term change should trigger search and return matching locations")
        
        viewModel.$locations
            .dropFirst()
            .sink { locations in
                
                XCTAssertEqual(locations.count, 2)
                XCTAssertEqual(locations[0].name, expectedLocations[0].name)
                XCTAssertEqual(locations[1].name, expectedLocations[1].name)
                
                expectation.fulfill()
                
            }.store(in: &cancellables)
        
        let searchTerm = "Vancouver"
        viewModel.searchTerm = searchTerm
                
        await fulfillment(of: [expectation] ,timeout: 0.55) // need to wait at least 0.5 seconds, because debounce(0.5) is set for the `searchTerm` publisher
    }
    
    @MainActor
    func testSearchTermChangeShouldTriggerLocalizedErrorWhenSearchFails() async {
        let useCase = SearchLocationUseCase(locationRepository: locationRepository)
        
        let viewModel = SearchLocationViewModel(
            searchLocationUseCase: useCase,
            onLocationSelected: { _ in }
        )
        
        XCTAssertTrue(viewModel.locations.isEmpty)
        
        await locationRepository.setError(URLError(.badServerResponse))
        
        let expectation = expectation(description: "Search term change should trigger localized error when search fails")
        
        viewModel.$localizedError
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, "The operation couldn’t be completed. (NSURLErrorDomain error -1011.)")
                expectation.fulfill()
            }.store(in: &cancellables)
        
        let searchTerm = "Vancouver"
        viewModel.searchTerm = searchTerm
        
        await fulfillment(of: [expectation], timeout: 0.55)
    }
    
    @MainActor
    func testEmptySearchTermShouldShowEmptyView() {
        let useCase = SearchLocationUseCase(locationRepository: locationRepository)
        
        let viewModel = SearchLocationViewModel(
            searchLocationUseCase: useCase,
            onLocationSelected: { _ in }
        )
        
        XCTAssertTrue(viewModel.locations.isEmpty)
        
        let expectation = expectation(description: "Empty search term should show empty view")
        
        viewModel.$isShowingEmptyView
            .dropFirst()
            .sink { isShowingEmptyView in
                XCTAssertTrue(isShowingEmptyView)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        viewModel.searchTerm = ""
        
        waitForExpectations(timeout: 0.55)
    }
    
    @MainActor
    func testSelectingLocationShouldTriggerOnLocationSelected() {
        let useCase = SearchLocationUseCase(locationRepository: locationRepository)
        
        var selectedLocation: SearchedLocation?
        
        let expectation = expectation(description: "onLocationSelected should be called when user make a selection")
        
        let viewModel = SearchLocationViewModel(
            searchLocationUseCase: useCase,
            onLocationSelected: { location in
                selectedLocation = location
                expectation.fulfill()
            }
        )
        
        let expectedLocation = SearchedLocation(latitude: -123.1207, longitude: 49.2827, name: "Vancouver, BC")
        
        viewModel.didSelect(location: expectedLocation)
        
        wait(for: [expectation])
        XCTAssertEqual(selectedLocation, expectedLocation)
    }
    
    private let locationRepository = MockLocationRepository()
    private var cancellables = Set<AnyCancellable>()
}
