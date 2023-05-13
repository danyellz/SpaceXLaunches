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
				Text(launch.mission_name)
			}

			if viewModel.isReadyForPaging {
				Rectangle()
					.background(Color.clear)
					.onAppear {
						viewModel.getLaunchList()
					}
			}
			
		}
		.background(Color.white)
        .padding()
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
