import SwiftUI

struct HomeScreen: View {
	@StateObject var vm = MatchViewModel()
	
	// Нижнее TabMenu со вкладками
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
			ProfileView()
				.tabItem {
					Label("Profile", image: "person.crop.circle")
				}
		}
	}
	
	// Основной контент HomeScreen
	var matchesList: some View {
		ZStack {
			backGround
			VStack {
				GameFilterView(gameSelected: $vm.gameSelected)
				TimeLineView(dateSelected: $vm.dateSelected)
				ScrollViewReader { proxy in
					ScrollView {
						if vm.isLoading {
							DataLoadingProgressView()
						} else {
							if vm.matches.isEmpty {
								NoMatchesView()
							} else {
								showMatches
							}
						}
					}
					// Возврат ScrollView вверх при обновлении матчей
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
		return RadialGradient(
			colors: [.blue.opacity(0.8), .black],
			center: .top,
			startRadius: 1,
			endRadius: 400
		)
		.ignoresSafeArea()
	}
	var showMatches: some View {
		LazyVStack(spacing: 0) {
			ForEach(vm.matches) { match in
				MatchesView(match: match)
					.padding(.horizontal, 20)
					.id(match.id)
			}
		}
	}
}



#Preview {
	HomeScreen()
}
