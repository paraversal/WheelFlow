//
//  RadialLayout.swift
//  WheelFlow
//
//  Created by paraversal on 06.09.23.
//

import SwiftUI

// kindly taken from https://designcode.io/swiftui-handbook-radial-layout

struct RadialLayout: Layout {
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		proposal.replacingUnspecifiedDimensions()
	}

	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		
		let radius = bounds.width / 3.2
		
		let angle = Angle.degrees(360.0 / Double(subviews.count)).radians

		for (index, subview) in subviews.enumerated() {
			// Position
			var point = CGPoint(x: 0, y: -radius).applying(CGAffineTransform(rotationAngle: CGFloat(angle) * CGFloat(index)))

			// Center
			point.x += bounds.midX
			point.y += bounds.midY

			// Place subviews
			subview.place(at: point, anchor: .center, proposal: .unspecified)
		}
	}
}

