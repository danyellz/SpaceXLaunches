//
//  SpaceXRocket.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation

struct SpaceXRocket: Codable {
	let first_stage: SpaceXRocketFirstStage
}

struct SpaceXRocketFirstStage: Codable {
	let cores: [SpaceXRocketCore]
}

struct SpaceXRocketCore: Codable {
	let land_success: Bool?
}
