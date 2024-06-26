import SwiftUI
import Foundation
import Combine
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

// MARK: Views

struct HomeScreen: View {
	@StateObject var vm = DataViewModel()
	
	var body: some View {
		ZStack {
			background
			VStack {
				GameFilterView(gameSelected: $vm.gameSelected)
				TimeLineView(dateSelected: $vm.dateSelected)
				ScrollView {
					LazyVStack(spacing: 0) {
						ForEach(vm.matches) { match in
							MatchView(match: match)
								.padding(.horizontal, 20)
						}
					}
				}
			}
		}
	}
}

extension HomeScreen {
	var background : some View {
		return RadialGradient(colors: [.blue.opacity(0.8), .black], center: .top, startRadius: 1, endRadius: 400).ignoresSafeArea()
	}
}

#Preview {
	HomeScreen()
}
