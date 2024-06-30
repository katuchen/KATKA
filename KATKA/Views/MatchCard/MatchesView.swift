import SwiftUI

struct MatchesView : View {
	let match : MatchModel
	
	@State private var primaryColor1: Color = .clear
	@State private var primaryColor2: Color = .clear
	
	var body: some View {
		let opponentFirst = match.opponents?.first?.opponent
		let opponentSecond = match.opponents?.last?.opponent
		
		HStack {
			OpponentView(
				opponentName: opponentFirst?.name ?? "TBD",
				logoURL: opponentFirst?.imageURL,
				primaryColor: $primaryColor1
			)
			Spacer()
			CentralInfoView(
				league: match.league?.name ?? "",
				matchDate: match.beginAt ?? "Unknown",
				matchType: match.matchType ?? "",
				numberOfGames: match.numberOfGames ?? 0,
				status: match.status ?? "",
				results: match.results ?? []
			)
			Spacer()
			OpponentView(
				opponentName: (opponentSecond?.name == opponentFirst?.name ? "TBD" : opponentSecond?.name) ?? "TBD",
				logoURL: (opponentSecond?.imageURL == opponentFirst?.imageURL ? URL(string: "") : opponentSecond?.imageURL),
				primaryColor: $primaryColor2
			)
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(LinearGradient(gradient: Gradient(
					colors: [primaryColor1, primaryColor2]),
									 startPoint: .bottomLeading,
									 endPoint: .bottomTrailing)))
		.padding(.vertical, 10)
	}
}
