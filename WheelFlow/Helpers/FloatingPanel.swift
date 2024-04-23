//
//  FloatingPanel.swift
//  WheelFlow
//
//  Created by paraversal on 08.09.23.
//

import AppKit

class FloatingPanel: NSPanel {
	init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
		// nonactivatingPanel makes it so the app is not set to active when the panel is opened or clicked
		// titled makes the window look like a standard Mac UI Window. Here mainly useful for the dropshadow.
		// fullSizeContentView allows the content to go over the space that is normally reserved for the titlebar.
		super.init(contentRect: contentRect, styleMask: [.nonactivatingPanel, .titled, .fullSizeContentView], backing: backing, defer: flag)

		// Make sure that the panel is in front of almost all other windows
		self.isFloatingPanel = false
		self.level = .floating
		
		// Allow the panel to appear in a fullscreen space
		self.collectionBehavior.insert(.fullScreenAuxiliary)
		
		// Don't delete panel state when it's closed.
		self.isReleasedWhenClosed = false

		// Make it transparent, the view inside will have to set the background.
		// This is necessary because otherwise, we will have some space for the titlebar on top of the height of the view itself which we don't want.
		self.isOpaque = false
		self.backgroundColor = .clear
		
		// Since we don't show a statusbar, this allows us to drag the window by its background instead of the titlebar.
		self.isMovableByWindowBackground = true
		self.titlebarAppearsTransparent = true
	}
}


