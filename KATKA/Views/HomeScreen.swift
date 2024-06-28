import SwiftUI

struct HomeScreen: View {
	@StateObject var vm = DataViewModel()
	
	var body: some View {
		TabView {
			matchesList
				.tabItem {
					Label("Matches", systemImage: "gamecontroller.fill")
				}
			LeaguesListView()
				.tabItem {
					Label("Leagues", systemImage: "chart.bar.doc.horizontal")
				}
			FavouritesView()
				.tabItem {
					Label("Following", systemImage: "star")
				}
		}
	}
	
	var matchesList: some View {
		ZStack {
			backGround
			VStack {
				GameFilterView(gameSelected: $vm.gameSelected)
				TimeLineView(dateSelected: $vm.dateSelected)
				ScrollViewReader { proxy in
					ScrollView {
						LazyVStack(spacing: 0) {
							withAnimation(.smooth) {
								ForEach(vm.matches) { match in
									MatchView(match: match)
										.padding(.horizontal, 20)
										.id(match.id)
								}
							}
						}
					}
					.scrollIndicators(.automatic)
					.onChange(of: vm.matches) { _,_ in
						withAnimation (.easeOut) {
							if let firstMatchID = vm.matches.first?.id {
								proxy.scrollTo(firstMatchID, anchor: .top)
							}
						}
					}
				}
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
