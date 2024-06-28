import SwiftUI

struct LeaguesListView: View {
	let leagues = ["TI", "ESL", "BLAST", "A", "B", "C", "D"]
	var body: some View {
		NavigationStack {
			ZStack {
				backGround
				List(leagues, id: \.self) { league in
					NavigationLink(league, value: league)
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

#Preview {
	LeaguesListView()
}
