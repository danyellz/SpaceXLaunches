//
//  SpaceXLaunch.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation

struct SpaceXLaunch: Codable {
	let mission_name: String
	let rocket: SpaceXRocket
	let launch_success: Bool
	let links: SpaceXImageLinks

	var landSuccess: Bool? {
		rocket.first_stage.cores.first?.land_success
	}

	var imageURL: URL? {
		URL(string: links.mission_patch_small)
	}
}

extension SpaceXLaunch: Identifiable {
	var id: String {
		mission_name
	}
}

struct SpaceXImageLinks: Codable {
	let mission_patch_small: String
}
