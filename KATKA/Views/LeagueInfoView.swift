import SwiftUI

struct LeagueInfoView: View {
	let league : LeagueModel
    var body: some View {
		Text(league.name ?? "")
		Text(league.videogame?.name.rawValue ?? "")
    }
}
