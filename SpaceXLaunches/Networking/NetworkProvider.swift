//
//  NetworkProvider.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation
import Combine

/// Service for making base HTTP calls for raw data, with a result type of AnyPublisher<T, Error> resolving to a publisher of Decodable type defined in parent services.
class NetworkProvider {
	typealias RESTPublisher<T> = AnyPublisher<T, Error>
	private let session = URLSession(configuration: .default)

	enum RequestType: String {
		case GET
	}

	func requestData<T: Decodable>(url: URL) -> AnyPublisher<T, Error> {
		return makeDataRequest(buildRequest(url: url))
			.decode(type: T.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}

	/// - Build a URL request
	private func buildRequest(type: RequestType = .GET, url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = type.rawValue
		return request
	}

	/// - Request raw data at a specified URL, returing a Publisher of type Data.
	func makeDataRequest(_ urlRequest: URLRequest) -> RESTPublisher<Data> {
		session.dataTaskPublisher(for: urlRequest)
			.tryMap { data, response -> Data in
				return data
			}
			.eraseToAnyPublisher()
	}
}
