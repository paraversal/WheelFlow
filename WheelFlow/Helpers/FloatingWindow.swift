//
//  FloatingWindow.swift
//  WheelFlow
//
//  Created by jules on 04.09.23.
//

import SwiftUI

/// Custom view modifier for floating windows

extension View{
	@ViewBuilder
	func floatingWindow<Content: View>(position: CGPoint, show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content) -> some View{
		self
			.modifier(FloatingWindowModifier(windowView: content(), position: position, show: show))
	}
}

/// - Floating window Modifier

fileprivate struct FloatingWindowModifier<WindowView: View>: ViewModifier{
	var windowView: WindowView
	var position: CGPoint
	@Binding var show: Bool
	@State private var panel: FloatingPanelHelper<WindowView>?
	
	func body(content: Content) -> some View {
		content
			.onAppear {
				panel = FloatingPanelHelper(position: position, show: $show, content: {
					windowView
				})
				// broken center code
				// panel?.center()
			}
			.background(content: {
				ViewUpdater(content: windowView, panel: $panel)
			})
			/// - change position dynamically
			.onChange(of: position, perform: { newValue in
				panel?.updatePosition(newValue)
			})
			.onChange(of: show) { newValue in
				if newValue{
					panel?.orderFront(nil)
					// throwing errror messages, uncomment if app breaks
					// panel?.makeKey()
				} else {
					panel?.close()
				}
			}
	}
}

fileprivate struct ViewUpdater<Content: View>: NSViewRepresentable{
	var content: Content
	@Binding var panel: FloatingPanelHelper<Content>?
	func makeNSView(context: Context) -> NSView {
		// - Simply Return Empty View
		return NSView()
	}
	func updateNSView(_ nsView: NSView, context: Context) {
		// - Update Panel's Hosting View
		if let hostingView = panel?.contentView as? NSHostingView<Content>{
			hostingView.rootView = content
		}
	}
}

/// - Creating floating panel using NSPanel
fileprivate class FloatingPanelHelper<Content: View>: NSPanel {
	@Binding private var show: Bool
	
	init(position: CGPoint, show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content) {
		/// custom window mask into stylemask
		self._show = show
		super.init(contentRect: .zero, styleMask: [.resizable, .closable, .fullSizeContentView, .nonactivatingPanel], backing: .buffered, defer: false)
	
		/// - Window properties
		isFloatingPanel = true
		level = .floating
		titleVisibility = .hidden
		titlebarAppearsTransparent = true
		
		standardWindowButton(.closeButton)?.isHidden = true
		standardWindowButton(.miniaturizeButton)?.isHidden = true
		standardWindowButton(.zoomButton)?.isHidden = true
		
		backgroundColor = .clear
		
		contentView = NSHostingView(rootView: content())
	}
	
	func updatePosition(_ to: CGPoint) {
		self.setFrameOrigin(to)
	}
	
}
