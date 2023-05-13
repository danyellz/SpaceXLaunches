//
//  TelemetryLineView.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import SwiftUI

struct TelemetryLineView: View {
	let circleRelativeCenters: [CGPoint]

	var body: some View {
		GeometryReader { geometry in
			let normalizedCenters = circleRelativeCenters
				.map { center in
					CGPoint(
						x: center.x * geometry.size.width,
						y: center.y * geometry.size.height
					)
				}

			Path { path in
				guard !normalizedCenters.isEmpty else { return }
				
				var prevPoint = CGPoint(x: normalizedCenters[0].x / 4, y: normalizedCenters[0].y / 2)
				normalizedCenters.forEach { center in
					guard center != normalizedCenters.first else {
						prevPoint = center
						return
					}

					path.move(to: prevPoint)

					path.addQuadCurve(
						to: center,
						control: .init(
							x: (center.x + prevPoint.x) / 2,
							y: (center.y - prevPoint.y) / 2)
					)

					prevPoint = center
				}
			}
			.stroke(lineWidth: 3)
			.foregroundColor(.white)

			Path { path in
				let circleDiamter = 24
				let circleFrameSize = CGSize(width: circleDiamter, height: circleDiamter)
				let circleCornerSize = CGSize(width: circleDiamter / 2, height: circleDiamter / 2)
				normalizedCenters.forEach { center in
					path.addRoundedRect(
						in: CGRect(
							origin: CGPoint(
								x: center.x - circleFrameSize.width / 2,
								y: center.y - circleFrameSize.width / 2
							), size: circleFrameSize
						),
						cornerSize: circleCornerSize
					)
				}
			}
			.fill()
			.foregroundColor(.red)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding()
	}
}
