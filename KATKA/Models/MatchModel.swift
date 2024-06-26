import SwiftUI

struct MatchModel : Identifiable, Codable {
	let beginAt, endAt: String?
	let detailedStats, draw: Bool?
	let forfeit: Bool?
	let id: Int
	let league: LeagueModel?
	let leagueID: Int?
	let matchType: String?
	let name: String?
	let numberOfGames: Int?
	let opponents: [OpponentElement]
	let results: [ResultsModel]?
	let serie: SeriesModel?
	let serieID: Int?
	let slug, status: String?
	let tournament: TournamentModel?
	let tournamentID: Int?
	let videogame: VideogameModel?
	let winnerID: Int?
	let winnerType: String?
	enum CodingKeys: String, CodingKey {
		case beginAt = "begin_at"
		case endAt = "end_at"
		case detailedStats = "detailed_stats"
		case draw
		case forfeit
		case id
		case league
		case leagueID = "league_id"
		case matchType = "match_type"
		case name
		case numberOfGames = "number_of_games"
		case opponents
		case results
		case serie
		case serieID = "serie_id"
		case slug
		case status
		case tournament
		case tournamentID = "tournament_id"
		case videogame
		case winnerID = "winner_id"
		case winnerType = "winner_type"
	}
}
