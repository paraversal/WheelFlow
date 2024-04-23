//
//  iconExtension.swift
//  WheelFlow
//
//  Created by paraversal on 21.02.24.
//
import SwiftUI

extension NSWorkspace {
	func icon(for url: String, height: Int) -> NSImage {
		let image = icon(forFile: url)
		image.size = NSSize(width: height, height: height)
		return image
	}
}
