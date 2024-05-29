//
//  LocationReponseTests.swift
//  WeatherTests
//
//  Created by Jing Yu on 2024-05-28.
//

import XCTest
@testable import Weather

final class LocationReponseTests: XCTestCase {

    func testCanInitWithJson() throws {
        let bundle = Bundle(for: LocationReponseTests.self)
        let url = bundle.url(forResource: "openweather_geo_coding_api_sample_response", withExtension: "json")!
        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let response = try decoder.decode([LocationResponse].self, from: data)
        
        XCTAssertEqual(response.count, 10)
        let london = response[0]
        XCTAssertEqual(london.name, "London")
        XCTAssertEqual(london.lat, 51.5073219)
        XCTAssertEqual(london.lon, -0.1276474)
        XCTAssertEqual(london.country, "GB")
        XCTAssertEqual(london.state, "England")
    }

}
