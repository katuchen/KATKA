import SwiftUI

struct TournamentModel : Identifiable, Codable {
	let id : Int
	let name : String?
	let beginAt, endAt : String?
	let detailedStats : Bool?
	let league : LeagueModel?
	let leagueID : Int?
	let matches : [MatchModel]?
	let prizepool : String?
	let serie : SeriesModel?
	let serieID : Int?
	let slug : String?
	let teams : [TeamModel]?
	enum Tier : String {
		case s = "S"
		case a = "A"
		case b = "B"
		case c = "C"
		case d = "D"
		case unranked = "Unranked"
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case beginAt = "begin_at"
		case endAt = "end_at"
		case detailedStats = "detailed_stats"
		case league
		case leagueID = "league_id"
		case matches
		case prizepool
		case serie
		case serieID = "serie_id"
		case slug
		case teams
	}
}
