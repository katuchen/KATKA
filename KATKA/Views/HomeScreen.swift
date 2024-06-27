import SwiftUI
import UIKit

struct HomeScreen: View {
	@StateObject var vm = DataViewModel()
	
	var body: some View {
		ZStack {
			backGround
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
				.scrollIndicators(.hidden)
			}
		}
	}
}

extension HomeScreen {
	var backGround : some View {
		return RadialGradient(colors: [.blue.opacity(0.8), .black], center: .top, startRadius: 1, endRadius: 400).ignoresSafeArea()
	}
}

#Preview {
	HomeScreen()
}
