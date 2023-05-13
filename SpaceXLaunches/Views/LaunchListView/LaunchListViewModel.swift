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

	// MARK: - Bound view properties

	@Published var launchList: [SpaceXLaunch] = []
	@Published var isErrorShowing = false
	
	/// - Fetch list of SpaceX launches / auto-paginate on new fetches.
	func getLaunchList() {
		isReadyForPaging = false

		launchService.getLaunchList(offset: offset)
		.receive(on: DispatchQueue.main)
		.delay(for: 1, scheduler: DispatchQueue.main)
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
}
