//
//  DIContainer.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

/// - Used for injection of shared resources using a key/value store (Service Locator).
protocol DependenciesProtocol {
	func register<Component>(type: Component.Type, component: Any)
	func resolve<Component>(type: Component.Type) -> Component?
}

final class Dependencies: DependenciesProtocol {
	static let shared = Dependencies()
	var components: [String: Any] = [:]
	
	func register<Component>(type: Component.Type, component: Any) {
		components["\(type)"] = component
	}
	
	func resolve<Component>(type: Component.Type) -> Component? {
		return components["\(type)"] as? Component
	}
}
