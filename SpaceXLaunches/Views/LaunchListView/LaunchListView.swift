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
		.preferredColorScheme(.dark)
		.onAppear {
			viewModel.getLaunchList()
		}
		.alert(viewModel.errorMessage, isPresented: $viewModel.isErrorShowing) {
			Button("OK", role: .cancel) {}
		}
    }

	 @ViewBuilder private var headerView: some View {
		if viewModel.showHeader {
			withAnimation {
				return VStack(alignment: .center) {
					TelemetryLineView(circleRelativeCenters: viewModel.selectedTelemetry)
				}
			}
			.frame(height: 200)
			.zIndex(0)
		} else {
			Rectangle()
				.frame(height: .zero)
		}
	}

	private var launchListView: some View {
		List {
			ForEach(viewModel.launchList) { launch in
				launchRow(launch: launch)
					.onAppear {
						withAnimation {
							guard viewModel.isReadyForPaging else { return }
							viewModel.showHeader = false
						}
					}
			}

			if viewModel.isReadyForPaging {
				HStack {
					Spacer()
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .white))
						.onAppear {
							viewModel.getLaunchList()
						}
					Spacer()
				}
			}
		}
		.listStyle(.plain)
		.zIndex(1)
	}

	private func launchRow(launch: SpaceXLaunch) -> some View {
		Button(action: { viewModel.selectLaunch(id: launch.id) }) {
			HStack(alignment: .top) {
				if let imageURL = launch.imageURL {
					CacheImageView(imageURL: imageURL, referenceFrame: 40)
				}

				VStack(alignment: .leading, spacing: 2) {
					Text(launch.mission_name)
						.font(.title2.bold())
					Text(launch.details ?? "No Details")
						.lineLimit(nil)
						.fixedSize(horizontal: false, vertical: true)
						.font(.footnote)
				}
				.padding(.horizontal)

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
		.frame(minHeight: 56)
	}
}

struct LaunchListView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchListView()
    }
}
