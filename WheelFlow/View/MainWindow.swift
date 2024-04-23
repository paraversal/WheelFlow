//
//  Home.swift
//  WheelFlow
//
//  Created by paraversal on 04.09.23.
//

import SwiftUI
import Foundation
import KeyboardShortcuts

struct MainWindow: View {
	
	// TODO: give users ability to change these hotkeys
	//let hotkey = HotKey(key: .f20, modifiers: [.command])
	//let hotkeyControl = HotKey(key: .f20, modifiers: [.control])
	
	@State private var showUI: Bool = false
	@State private var position: CGPoint = .zero

	@State private var currentSelectionApp: String = ""
	
	@AppStorage("hideOnActiveTrigger") var hideOnActiveTrigger: Bool = false;
	
	@AppStorage("appList") private var appList: [String] = []
	@AppStorage("appListSecondary") private var appListSecondary: [String] = []
	
	@State var appListControl: [String] = []
	@State var tempAppList: [String] = []
	
	var body: some View {
		
		VStack {
			
			MainWindowContents(appList: $appList, secondaryAppList: $appListSecondary, hideOnFocusedTrigger: $hideOnActiveTrigger)
			
		}
		.padding()
		.onAppear{
			
			KeyboardShortcuts.onKeyDown(for: .primaryKeyDown) { [self] in keyAction() }
			KeyboardShortcuts.onKeyDown(for: .secondaryKeyDown) { [self] in keyUpAction() }
			
			KeyboardShortcuts.onKeyUp(for: .primaryKeyDown) { [self] in keyUpAction() }
			KeyboardShortcuts.onKeyUp(for: .secondaryKeyDown) { [self] in keyUpAction2() }

		}
		.floatingWindow(position: position, show: $showUI){
			GeometryReader{_ in
				// let size = $0.size
				WheelView(appList: $appList, currentSelectionApp:  $currentSelectionApp, uiIsShowing: $showUI)
			}
			.frame(width: 800, height: 800)
		}
		
	}
	
	
	private func keyAction2() {
			
			var coordinatesFromMousePosition: CGPoint {
				let mousePos = NSEvent.mouseLocation
				return .init(x: mousePos.x - 300, y: mousePos.y - 500)
			}
			
			var screenMiddle: CGPoint {
				guard let screen = NSScreen.main?.visibleFrame.size else {return .zero}
				return .init(x: screen.width/2-500, y: screen.height/2-500)
			}
			let ws = NSWorkspace.shared
								
				let apps = ws.runningApplications
				for currentApp in apps
				{
					if(currentApp.activationPolicy == .regular &&  !(currentApp.bundleURL?.absoluteString.contains("WheelFlow") ?? true)){
						appListControl.append(currentApp.bundleURL?.absoluteString.replacingOccurrences(of: "file://", with: "") ?? "")
						
					}
				}
			
			tempAppList = appList
			appList = appListControl
			
			print(appListControl)
		
			position = coordinatesFromMousePosition
			showUI.toggle()
		}
	
	
	private func keyAction() {
		
		var coordinatesFromMousePosition: CGPoint {
			let mousePos = NSEvent.mouseLocation
			return .init(x: mousePos.x - 300, y: mousePos.y - 500)
		}
		
		var screenMiddle: CGPoint {
			guard let screen = NSScreen.main?.visibleFrame.size else {return .zero}
			return .init(x: screen.width/2-500, y: screen.height/2-500)
		}
		
		
		position = coordinatesFromMousePosition
		showUI.toggle()
	}
	
	private func keyUpAction2() {
			showUI = false
			appList = tempAppList
			
			tempAppList.removeAll()
			appListControl.removeAll()
		
			if (currentSelectionApp != "" && MainWindow.isValidTarget(urlString: currentSelectionApp.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)) ){
				if let url = NSWorkspace.shared.frontmostApplication?.bundleURL {
					if (url == URL(fileURLWithPath: currentSelectionApp.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)) && hideOnActiveTrigger){
						NSWorkspace.shared.frontmostApplication?.hide()
					} else {
						NSWorkspace.shared.openApplication(at: URL(string: "file:///"+currentSelectionApp)!, configuration: NSWorkspace.OpenConfiguration())
					}
				}
			}
		}
	
	
	private func keyUpAction() {
		showUI = false
		if (currentSelectionApp != "" && MainWindow.isValidTarget(urlString: currentSelectionApp.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)) ){
			if let url = NSWorkspace.shared.frontmostApplication?.bundleURL {
				if (url == URL(fileURLWithPath: currentSelectionApp.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil)) && hideOnActiveTrigger){
					NSWorkspace.shared.frontmostApplication?.hide()
				} else {
					NSWorkspace.shared.openApplication(at: URL(string: "file:///"+currentSelectionApp)!, configuration: NSWorkspace.OpenConfiguration())
				}
			}
		}
	}
	
	public static func isValidTarget (urlString: String?) -> Bool {
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: urlString ?? "") {
			return true
		} else {
			return false
		}
	}
	

}

/*
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

*/
