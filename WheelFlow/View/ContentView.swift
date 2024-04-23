//
//  ContentView.swift
//  WheelFlow
//
//  Created by jules on 04.09.23.
//

import SwiftUI
import HotKey

struct Home: View {
	
	let hotkey = HotKey(key: .p, modifiers: [.option, .control])
	
	@State private var showUI: Bool = false
	@State private var position: CGPoint = .zero
	
    var body: some View {
        VStack {
			Button("show UI"){

				buttonAction()
				
			}
        }
        .padding()
		.onAppear{
			hotkey.keyDownHandler = buttonAction
		}
		.floatingWindow(position: position, show: $showUI){
			GeometryReader{
				let size = $0.size
				Image(systemName:"pencil.slash")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: size.width, height: size.height)
					.clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
			}
			.frame(width: 200, height: 200)
		}
		
    }
	
	
	private func buttonAction(){
		var screenMiddle: CGPoint {
					guard let screen = NSScreen.main?.visibleFrame.size else {return .zero}
					return .init(x: screen.width/2-100, y: screen.height/2-100)
				}
		
		position = screenMiddle
		showUI.toggle()
	}
	
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
