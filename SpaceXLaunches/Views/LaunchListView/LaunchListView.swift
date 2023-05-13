//
//  LaunchListView.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import SwiftUI

struct LaunchListView: View {
	@ObservedObject var viewModel = LaunchListViewModel()
	
    var body: some View {
		VStack {
			headerView
			launchListView
		}
		.onAppear {
			viewModel.getLaunchList()
		}
    }

	 @ViewBuilder private var headerView: some View {
		if viewModel.showHeader {
			withAnimation {
				return VStack(alignment: .center) {
					TelemetryLineView(circleRelativeCenters: viewModel.selectedTelemetry)
				}
				.frame(maxWidth: .infinity, maxHeight: 200)
			}
		} else {
			EmptyView()
		}
	}

	private var launchListView: some View {
		List {
			ForEach(viewModel.launchList) { launch in
				launchRow(launch: launch)
					.onAppear {
						viewModel.showHeader = false
					}
			}

			if viewModel.isReadyForPaging {
				HStack {
					Spacer()
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .blue))
						.onAppear {
							viewModel.getLaunchList()
						}
					Spacer()
				}
			}
		}
	}

	private func launchRow(launch: SpaceXLaunch) -> some View {
		Button(action: { viewModel.selectLaunch(id: launch.id) }) {
			HStack {
				if let imageURL = launch.imageURL {
					CacheImageView(imageURL: imageURL, referenceFrame: 48)
				}

				Text(launch.mission_name)
					.padding()

				Spacer()

				VStack(spacing: 4) {
					Text(launch.launch_success ? "Launch" : "BOOM")
						.padding(.horizontal, 8)
						.background(launch.launch_success ? Color.green : Color.red)
						.clipShape(Capsule())

					if launch.landSuccess == true {
						Text("Landed")
							.padding(.horizontal, 8)
							.background(Color.blue)
							.clipShape(Capsule())
					}
				}
			}
		}
		.tint(.white)
	}
}

struct LaunchListView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchListView()
    }
}
