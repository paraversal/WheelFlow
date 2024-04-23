//
//  WheelView.swift
//  WheelFlow
//
//  Created by paraversal on 05.09.23.
//

import SwiftUI
import TrapezoidShapes

struct WheelView: View {
	
	@Binding var appList: [String]
	
	@Binding var currentSelectionApp: String
	
	@State private var lastHoveredId = ""
	
	@Binding var uiIsShowing: Bool
	
	var body: some View {
	
			
		RadialLayout {
			ForEach(0 ..< appList.count, id: \.self) { i in
				WheelSliceView(objectIndex: i, totalObjectAmount: appList.count, launchPath: appList[i], currentSelectionBinding: $currentSelectionApp, lastHoveredId: $lastHoveredId)
				// see https://stackoverflow.com/questions/65841298/swiftui-onhover-doesnt-register-mouse-leaving-the-element-if-mouse-moves-too-fa
					.onHover { isHovered in
						if isHovered {
							lastHoveredId = String(i)
							currentSelectionApp = appList[i] }
						else if lastHoveredId == String(i) {
							currentSelectionApp = ""
							lastHoveredId = ""
						}
					}
					.onChange(of: uiIsShowing) { newValue in
						if newValue == false {
							lastHoveredId =  ""
						}
					}
			}
		}.frame(width: 600, height: 600)
	}
}

struct WheelView_Previews: PreviewProvider {
	
	@State static var appList: [String] = [
		"/Applications/Visual%20Studio%20Code.app",
		"/Applications/Spotify.app",
		"/Applications/Discord.app"
	]
	
	@State static var appList2: [String] = [
			"/Applications/Visual%20Studio%20Code.app","/Applications/Spotify.app",
			"/Applications/Discord.app","/Applications/Firefox.app",
			"/Applications/Xcode.app",
		]
	
	@State static var appList3: [String] = [
				"/Applications/Visual%20Studio%20Code.app","/Applications/Spotify.app",
				"/Applications/Discord.app","/Applications/Xcode.app",
				"/Applications/Audacity.app","/Applications/Firefox.app",
				"/Applications/Alacritty.app",
			]
	
	@State static var appList4: [String] = [
			"/Applications/Visual%20Studio%20Code.app","/Applications/Spotify.app",
			"/Applications/Discord.app","/Applications/Blender.app",
			"/Applications/Alacritty.app","/Applications/HandBrake.app",
			"/Applications/Thunderbird.app","/Applications/RStudio.app",
			"/Applications/Typeface.app","/Applications/Todoist.app",
			"/Applications/Pycharm.app","/Applications/Zed.app"
		]

					  
	
	@State static var current: String = ""

	@State static var uiIsShowing = false
	
	static var previews: some View {

		VStack {
			HStack {
				WheelView(appList: $appList, currentSelectionApp: $current, uiIsShowing: $uiIsShowing)
				WheelView(appList: $appList2, currentSelectionApp: $current, uiIsShowing: $uiIsShowing)
			}
			HStack {
				WheelView(appList: $appList3, currentSelectionApp: $current, uiIsShowing: $uiIsShowing)
				WheelView(appList: $appList4, currentSelectionApp: $current, uiIsShowing: $uiIsShowing)
			}
		}
	}
}

