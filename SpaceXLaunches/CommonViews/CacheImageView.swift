//
//  CacheImageView.swift
//  SpaceXLaunches
//
//  Created by Ty Daniels on 5/12/23.
//

import Foundation
import SwiftUI
import Kingfisher

struct CacheImageView: View {
	let imageURL: URL
	let referenceFrame: CGFloat

	var body: some View {
		KFImage(imageURL)
			.placeholder {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle(tint: .blue))
			}
			.setProcessor(ResizingImageProcessor(referenceSize: referenceSize, mode: .aspectFill))
			.cacheOriginalImage()
			.fade(duration: 0.25)
			.resizable()
			.frame(width: referenceFrame, height: referenceFrame)
			.cornerRadius(4)
	}

	private var referenceSize: CGSize {
		CGSize(width: referenceFrame * UIScreen.main.scale, height: referenceFrame * UIScreen.main.scale)
	}
}

struct CacheImageView_Previews: PreviewProvider {
	static var previews: some View {
		CacheImageView(imageURL: URL(string: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")!, referenceFrame: UIScreen.main.scale)
	}
}
