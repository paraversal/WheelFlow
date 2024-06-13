//
//  AppListView.swift
//  WheelFlow
//
//  Created by paraversal on 06.09.23.
//

import SwiftUI
import KeyboardShortcuts

struct MainWindowContents: View {
	
	@Binding var appList: [String]
	@Binding var secondaryAppList: [String]
	
	@State private var selection: String? = nil
	
	@Binding var hideOnFocusedTrigger: Bool
	
	@State private var selectedItem = 1
	
	var body: some View {
		VStack {
			Text("Apps")
			.font(.title)
			.bold()
			.padding()
			
			TabView(selection: $selectedItem) {
				ListAppView(appList: $appList)
				.listStyle(.inset)
				.animation(.spring, value: appList)
				.tabItem { Label("Primary", systemImage: "1.circle") }
				.tag(1)
				ListAppView(appList: $secondaryAppList)
				.listStyle(.inset)
				.animation(.spring, value: secondaryAppList)
				.tabItem { Label("Secondary", systemImage: "2.circle") }
				.tag(2)
				
			.padding()
			}
			
			SettingsView(selectedAppPage: $selectedItem, hideOnFocusedTrigger: $hideOnFocusedTrigger)
			.padding(10)
			Divider()
			
			AddAppView(appListBinding: $appList, secondaryAppListBinding: $secondaryAppList, focused: $selectedItem)
			.padding()

		}
		
	}
	
	public static func generateIconViewFromPath(appPath: String) -> Image {
		let icon = NSWorkspace.shared.icon(for: appPath.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil), height: 256)
		return Image(nsImage: icon).interpolation(.high).antialiased(true)
			
		}
	
	public static func generateNameFromPath(appPath: String) -> String {
		let pattern = /([^\/]*(?=\.app))/
		if let match = appPath.firstMatch(of: pattern) {
			return "\(match.1.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil))"
		} else {
			return appPath
		}
	}
		
}


struct ListAppView: View {
	@Binding var appList: [String]
	
	var body: some View {
		List {
			ForEach($appList, id: \.self) { i in
				HStack {
					MainWindowContents.generateIconViewFromPath(appPath: i.wrappedValue)
						.frame(width: 50, height: 50)
						.scaleEffect(0.21)
						.padding(.trailing, 20)
						
					Text(MainWindowContents.generateNameFromPath(appPath: i.wrappedValue))
					Text(i.wrappedValue.replacingOccurrences(of: "%20", with: " ", options: .literal, range: nil))
						.foregroundColor(.gray)
				}.contextMenu {
					Button(action: {
						deleteItem(item: i.wrappedValue)
					}){
						Text("Delete")
					}
				}.padding()
				
			}.onMove { indices, destination in
				appList.move(fromOffsets: indices,
					toOffset: destination)
			}
		}
	}
	
	func deleteItem(item: String) {
		   if let index = appList.firstIndex(of: item) {
			   appList.remove(at: index)
		   }
	   }
	
}

struct SettingsView: View {
	@Binding var selectedAppPage: Int
	@Binding var hideOnFocusedTrigger: Bool
	
	var body: some View {
		VStack {
			// APP PAGE SHORTCUTS
			switch selectedAppPage{
				case 1:
					Form { KeyboardShortcuts.Recorder("Primary Page:", name: .primaryKeyDown) }.padding(.bottom, 5)
				case 2:
					Form { KeyboardShortcuts.Recorder("Secondary Page:", name: .secondaryKeyDown) }.padding(.bottom, 5)
				default:
					EmptyView()
			}
			
			// HIDE ACTIVE APPS TRIGGER
			Toggle("Hide active apps when reselected", isOn: $hideOnFocusedTrigger)
				.toggleStyle(.switch)
		}
	}
}

struct AddAppView: View {
	
	@Binding var appListBinding: [String]
	@Binding var secondaryAppListBinding: [String]
	
	@Binding var focused: Int
	
	@State var toAddAppPath: String = ""
	
	@State var notValidPathState = false
	
	var body: some View {
		HStack {
			TextField("App path", text: $toAddAppPath)
			.font(.body.monospaced())
			.background(notValidPathState ? .red : .clear)
			.foregroundColor(notValidPathState ? .red : .gray)
			.textFieldStyle(.roundedBorder)
			Button("Add") {
				addAppToList()
			}
			.keyboardShortcut(.defaultAction)
			.clipShape(RoundedRectangle(cornerRadius: 7))
		}
		
	}
	
	func addAppToList() {
		
		if (!MainWindow.isValidTarget(urlString: toAddAppPath)) {
			notValidPathState = true
			return
		} else if (appListBinding.contains(toAddAppPath.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))) {
			notValidPathState = true
			return
		} else if (toAddAppPath != ""){
			switch focused {
				case 1:
					appListBinding.append(toAddAppPath.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))
					break;
				default:
					secondaryAppListBinding.append(toAddAppPath.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil))
					break;
			}
			notValidPathState = false
			toAddAppPath = ""
			
			
		}
	}

	
}

struct AppListView_Previews: PreviewProvider {
		
	@State static var appListCommand = [
		"/Applications/Visual%20Studio%20Code.app",
				"/Applications/Spotify.app",
				"/Applications/Discord.app"
		]
	
	@State static var isOn = true;
	
	static var previews: some View {
	
		MainWindowContents(appList: $appListCommand, secondaryAppList: $appListCommand, hideOnFocusedTrigger: $isOn)
		.frame(width:500, height: 800)
		
	}
}

