//
//  WheelFlowApp.swift
//  WheelFlow
//
//  Created by paraversal on 04.09.23.
//

import SwiftUI

@main
struct WheelFlowApp: App {
	
	var body: some Scene {
		WindowGroup {
			MainWindow()
				.frame(minWidth: 550, idealWidth: 550, minHeight: 800, idealHeight: 800)
			
		}
		
	}
		
		//WindowGroup("Settings") {
		//			SettingsView()
		//		}
		//		.commands {
		//			CommandGroup(replacing: .newItem) {}
		//		}
		
    

}


