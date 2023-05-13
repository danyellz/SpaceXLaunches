//
//  HTTPClient.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation

/// - HTTP URL builder
struct HTTPClient {
	private static let scheme = "https"
	private static let host = "api.spacexdata.com"

	enum HTTPRequest {
		case launches(limit: Int, offset: Int)

		private var mainPath: String {
			switch self {
			case .launches:
				return "/v3/launches"
			}
		}

		private var queryItems: [URLQueryItem] {
			switch self {
			case .launches(let limit, let offset):
				return [
					URLQueryItem(name: "limit", value: "\(limit)"),
					URLQueryItem(name: "offset", value: "\(offset)"),
					URLQueryItem(name: "pretty", value: "true")
				]
			}
		}

		private var urlComponents: URLComponents {
			var components = URLComponents()
			components.scheme = HTTPClient.scheme
			components.host = HTTPClient.host
			components.path = mainPath
			components.queryItems = queryItems
			return components
		}

		var requestURL: URL? {
			return urlComponents.url
		}
	}
}
