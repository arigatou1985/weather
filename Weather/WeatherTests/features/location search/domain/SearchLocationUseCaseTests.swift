//
//  SearchLocationUseCaseTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-29.
//

import XCTest
@testable import Weather

final class SearchLocationUseCaseTests: XCTestCase {
    func testSearchLocationsShouldReturnMatchingLocations() async {
        let useCase = SearchLocationUseCase(
            locationRepository: locationRepository
        )
        
        let allLocations = locationRepository.sampleLocations
        let expectedLocations = allLocations.filter { $0.name.contains("Vancouver") }
        
        await locationRepository.setLocation(allLocations)
        
        do {
            let locations = try await useCase.searchLocations(matching: "Vancouver")
            
            XCTAssertEqual(locations.count, 2)
            XCTAssertEqual(locations[0].name, expectedLocations[0].name)
            XCTAssertEqual(locations[1].name, expectedLocations[1].name)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func testSearchLocationsShouldThrowErrorIfLocationRepositoryThrowsError() async {
        let useCase = SearchLocationUseCase(
            locationRepository: locationRepository
        )
        
        await locationRepository.setError(URLError(.badServerResponse))
        
        do {
            _ = try await useCase.searchLocations(matching: "Vancouver")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as! URLError, URLError(.badServerResponse))
        }
    }
    
    private let locationRepository = MockLocationRepository()
}
