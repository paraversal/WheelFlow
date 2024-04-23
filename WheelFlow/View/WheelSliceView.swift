//
//  WheelSliceView.swift
//  WheelFlow
//
//  Created by paraversal on 06.09.23.
//

import SwiftUI
import TrapezoidShapes

struct WheelSliceView: View {
	
	@State private var hovered = false
	
	let objectIndex: Int
	
	let launchPath: String
	
	let rotation: Angle
	
	@Binding var lastHoveredId: String

	@Binding var currentSelection: String
	
	var totalObjectAmount: Double
	
	init(objectIndex: Int, totalObjectAmount: Int, launchPath: String, currentSelectionBinding: Binding<String>, lastHoveredId: Binding<String>) {
			self.objectIndex = objectIndex
			self.launchPath = launchPath
			self.rotation = WheelSliceView.setRotation(index: objectIndex, totalObjectAmount: totalObjectAmount)
			self.totalObjectAmount = Double(totalObjectAmount)
			self._currentSelection = currentSelectionBinding
			self._lastHoveredId = lastHoveredId
		}
	
	var body: some View {
			
			RoundedTrapezoid(cornerRadius: 30, edgeRatio: 0.6, flexibleEdge: .bottom)
				.fill(self.hovered ? Color("accentColor") : Color("backgroundColor"))
				.frame(width: floorToMax(600/totalObjectAmount, 100) , height: floorToMax(1200/totalObjectAmount, 200))
		
				.scaleEffect(self.hovered ? 1.1 : 1)
				.padding(.bottom, totalObjectAmount*(-6))
				.onChange(of: lastHoveredId) {
					/// - pretty sure the $0 means lastHoveredId
					if $0 == String(objectIndex) {
						withAnimation(.spring(response: 0.01)) {
							hovered = true
						}
						
						currentSelection = self.launchPath
					} else {
						withAnimation(.spring(response: 0.02)) {
							hovered = false
						}
					}
				}
				
				.overlay {
					
					VStack {
						
						MainWindowContents.generateIconViewFromPath(appPath: self.launchPath)
						.rotationEffect(-rotation, anchor: .center)
						.scaleEffect(0.125)
						.scaleEffect(floorToMax(13.8/totalObjectAmount, 2.3) )
						.padding(.bottom, floorToMax(540/totalObjectAmount-(totalObjectAmount*(8)), 90) )

						.shadow(radius: 4)
						.scaleEffect(self.hovered ? 1.1 : 1)
								
			}
			
		}.rotated(angle: rotation)
	}
	
	static func setRotation(index: Int, totalObjectAmount: Int) -> Angle {
		
		let degreeSeparation = 360/totalObjectAmount
		let rotationDegrees = degreeSeparation * index
		return Angle(degrees: Double(rotationDegrees))
	}
	
	func floorToMax(_ x: Double, _ max: Double) -> Double {
		return x > max ? max : x
	}
	
}

struct WheelSliveView_Previews: PreviewProvider {
		
		@State static var current: String = ""
	
		@State static var lastHoveredId: String = ""

	
	static var previews: some View {
		WheelSliceView(objectIndex: 0, totalObjectAmount: 5,  launchPath: "/Applications/Thunderbird.app", currentSelectionBinding: $current, lastHoveredId: $lastHoveredId)
	}
}

