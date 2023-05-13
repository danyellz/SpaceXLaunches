//
//  LaunchService.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation

/// - Service used for fetching and returning launch data AnyPublishers of Decodable response types.
class LaunchService {
	private var networkProvider = Dependencies.shared.resolve(type: NetworkProvider.self)!
	
	func getLaunchList(offset: Int) -> NetworkProvider.RESTPublisher<[SpaceXLaunch]> {
		let url = HTTPClient.HTTPRequest.launches(limit: 20, offset: offset).requestURL!
		
		return networkProvider.requestData(url: url)
			.eraseToAnyPublisher()
	}
}
