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
		List {
			ForEach(viewModel.launchList) { launch in
				HStack {
					if let imageURL = launch.imageURL {
						CacheImageView(imageURL: imageURL, referenceFrame: 48)
					}

					Text(launch.mission_name)
						.padding()
					Spacer()
				}
			}

			if viewModel.isReadyForPaging {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: .white))
					.onAppear {
						viewModel.getLaunchList()
					}
			}
		}
		.onAppear {
			viewModel.getLaunchList()
		}
    }
}

struct LaunchListView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchListView()
    }
}
