//
//  LaunchService.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation

/// - Service used for fetching and returning image metadata publishers of Decodable result types.
class LaunchService {
	private var networkProvider = Dependencies.shared.resolve(type: NetworkProvider.self)!
	
	func getImageList(offset: Int) -> NetworkProvider.RESTPublisher<[SpaceXLaunch]> {
		let url = HTTPClient.HTTPRequest.launches(limit: 20, offset: offset, year: 2023).requestURL!
		
		return networkProvider.requestData(url: url)
			.eraseToAnyPublisher()
	}
}
