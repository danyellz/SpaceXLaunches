//
//  SpaceXLaunchesTests.swift
//  SpaceXLaunchesTests
//
//  Created by Ty Daniels on 5/12/23.
//

import XCTest
import Combine
@testable import SpaceXLaunches

final class SpaceXLaunchTests: XCTestCase {
	var mockViewModel: LaunchListViewModel!
	private var cancellables = Set<AnyCancellable>()

	override func setUpWithError() throws {
		try super.setUpWithError()
		Dependencies.shared.register(type: NetworkProvider.self, component: MockNetworkProvider())
	}

	func testViewModelDataModeling() {
		let expectation = XCTestExpectation(description: "Data was fetched")
		mockViewModel = LaunchListViewModel()
		mockViewModel.getLaunchList()

		mockViewModel.$launchList.sink(receiveValue: { result in
			guard !result.isEmpty else { return }
			expectation.fulfill()
		})
		.store(in: &cancellables)

		wait(for: [expectation], timeout: 5)
		XCTAssertEqual(mockViewModel.launchList.count, 2)
	}
}

class MockNetworkProvider: NetworkProvider {
	override func makeDataRequest(_ urlRequest: URLRequest) -> RESTPublisher<Data> {
		let json: [[String: Any]] = [
			[
				"mission_name": "Falcon",
				"rocket": [
					"first_stage": [
						"cores": [
							[
								"land_success": true
							]
						]
					]
				],
				"launch_success": true,
				"links": [
					"mission_patch_small": "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png"
				]
			],
			[
				"mission_name": "Falcon-Heavy",
				"rocket": [
					"first_stage": [
						"cores": [
							[
								"land_success": true
							]
						]
					]
				],
				"launch_success": true,
				"links": [
					"mission_patch_small": "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png"
				]
			]
		]

		let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		let response = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
		return Just((data: jsonData, response: response))
			.tryMap { data, response -> Data in
				return data
			}
			.eraseToAnyPublisher()
	}
}
