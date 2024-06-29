import SwiftUI

struct LeaguesListView: View {
	let matches: [MatchModel]
	
	var body: some View {
		NavigationStack {
			ZStack {
				backGround
				List(matches) { match in
					Text("\(match.league?.id ?? 0)")
				}
				.listStyle(.grouped)
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
