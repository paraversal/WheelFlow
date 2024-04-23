//
//  AppModel.swift
//  WheelFlow
//
//  Created by paraversal on 07.09.23.
//

struct AppModel: Hashable {
	
	var appName: String
	var appPath: String

	// Implement the hash(into:) method
	func hash(into hasher: inout Hasher) {
		// Combine the hash values of the properties that contribute to equality
		hasher.combine(appName)
		hasher.combine(appPath)
	}

	// Implement the == operator to compare two AppModel instances for equality
	static func == (lhs: AppModel, rhs: AppModel) -> Bool {
		return lhs.appName == rhs.appName &&
			   lhs.appPath == rhs.appPath
	}
}

