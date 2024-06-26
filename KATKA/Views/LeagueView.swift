import SwiftUI

struct LeagueView : View {
	let match : MatchModel
	
	var body: some View {
		let leagueName = match.league?.name
		let tournamentName = match.tournament?.name
		let seriesName = match.serie?.name
		let logoURL = match.league?.imageURL
		
		AsyncImage(url: logoURL) { image in
			image
				.resizable()
				.scaledToFit()
				.frame(width: 20, height: 20)
		} placeholder: {
			Image(systemName: "circle.fill")
				.foregroundStyle(Color(.systemBlue))
				.frame(width: 20, height: 20)
		}
		.frame(width: 20, height: 20)
		VStack {
			Text("\(leagueName ?? "")")
				.font(.subheadline)
				.foregroundStyle(Color(.label))
				.bold()
			Text("\(seriesName ?? "") \(tournamentName ?? "")")
		}
		.font(.caption)
		.foregroundStyle(Color(.secondaryLabel))
		.multilineTextAlignment(.center)
		.lineLimit(1)
		.padding()
	}
}
