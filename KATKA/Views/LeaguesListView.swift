import SwiftUI

struct LeaguesListView: View {
	let leagues: [LeagueModel]
	
	var body: some View {
		NavigationStack {
			ZStack {
				backGround
				List(leagues) { league in
					NavigationLink {
						LeagueInfoView(league: league)
					} label: {
						Text(league.name ?? "")

					}
				}
				.listStyle(.automatic)
				.scrollContentBackground(.hidden)
			}
			.navigationTitle("Leagues")
		}
	}
}

extension LeaguesListView {
	var backGround : some View {
		return RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0, green: 0.9767891765, blue: 0, alpha: 1)).opacity(0.7), .black], center: .top, startRadius: 1, endRadius: 400).ignoresSafeArea()
	}
}
