//
//  LaunchListViewModel.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation
import Combine

/// View model for managing LaunchListView data modeling/abstraction, as well as firing view updates.
class LaunchListViewModel: ObservableObject {
	private var launchService = LaunchService()
	private var cancellables = Set<AnyCancellable>()
	private var offset = 0

	// MARK: - View Properties

	var errorMessage = String()
	var isReadyForPaging = false
	var selectedTelemetry: [CGPoint] = []

	// MARK: - Bound view properties

	@Published var launchSelected = false
	@Published var launchList: [SpaceXLaunch] = []
	@Published var isErrorShowing = false

	/// - Fetch list of SpaceX launches / auto-paginate on new fetches.
	func getLaunchList() {
		isReadyForPaging = false

		launchService.getLaunchList(offset: offset)
		.delay(for: 1, scheduler: DispatchQueue.main)
		.receive(on: DispatchQueue.main)
		.sink(receiveCompletion: { [unowned self] result in
			switch result {
			case .failure(let error):
				errorMessage = error.localizedDescription
				isErrorShowing = true
			default:
				break
			}
		}, receiveValue: { [unowned self] (result: [SpaceXLaunch]) -> Void in
			launchList.append(contentsOf: result)
			offset = launchList.count
			isReadyForPaging = true
		})
		.store(in: &cancellables)
	}

	func selectLaunch(id: String) {
		guard let selectedLaunch = launchList.first(where: { $0.id == id }) else { return }
		createTelemetry(selectedLaunch: selectedLaunch)
		launchSelected = !selectedTelemetry.isEmpty
	}

	private func createTelemetry(selectedLaunch: SpaceXLaunch) {
		selectedTelemetry = [
			selectedLaunch.launch_success ? Self.bottomLeft : nil,
			selectedLaunch.landSuccess ?? false ? Self.centerTop : nil,
			selectedLaunch.landSuccess ?? false ? Self.bottomRight : nil
		]
		.compactMap { $0 }
	}
}

// MARK: - Constants

fileprivate extension LaunchListViewModel {
	static let bottomLeft = CGPoint(x: 0, y: 1.0)
	static let centerTop = CGPoint(x: 0.5, y: 0.1)
	static let bottomRight = CGPoint(x: 1.0, y: 1.0)
}
