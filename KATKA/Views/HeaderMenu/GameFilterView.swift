import SwiftUI

struct GameFilterView : View {
	@Binding var gameSelected : String
	let slugToName: [VideogameModel.slug: VideogameModel.name] = [
		.cs: .cs,
		.dota: .dota,
		.leagueOfLegends: .leagueOfLegends,
		.valorant: .valorant,
		.codMW: .codMW,
		.fifa: .fifa,
		.kog: .kog,
		.lolWildRift: .lolWildRift,
		.mlbb: .mlbb,
		.overwatch: .overwatch,
		.pubg: .pubg,
		.r6Siege: .r6Siege,
		.rocketLeague: .rocketLeague,
		.starcraft2: .starcraft2,
		.starcraftBW: .starcraftBW
	]
	
	var body: some View {
		HStack {
			Menu {
				Button("All games") {
					gameSelected = MatchViewModel.allGames
				}
				ForEach(VideogameModel.slug.allCases, id: \.self) { slug in
					if let name = slugToName[slug] {
						Button(name.rawValue) {
							gameSelected = slug.rawValue
						}
					}
				}
			} label: {
				Text(slugToName.first(where: { $0.key.rawValue == gameSelected })?.value.rawValue ?? "All games")
					.font(.headline)
					.foregroundStyle(.white)
					.padding(.vertical, 5)
					.padding(.horizontal, 15)
					.background(
						RoundedRectangle(cornerRadius: 50)
							.fill(gameSelected != MatchViewModel.allGames ? Color(.systemBlue) : Color(.secondarySystemFill))
					)
			}
			
		}
		.padding(.horizontal, 40)
		.frame(maxWidth: .infinity, alignment: .trailing)
	}
}
