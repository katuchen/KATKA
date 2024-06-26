import SwiftUI

struct SeriesModel : Identifiable, Codable {
	let id, leagueID: Int
	let name: String?
	let fullName: String?
	let beginAt, endAt: String?
	let season, slug: String?
	let winnerID: Int?
	let winnerType : String?
	let year: Int
	
	enum CodingKeys: String, CodingKey {
		case id
		case leagueID = "league_id"
		case name
		case fullName = "full_name"
		case beginAt = "begin_at"
		case endAt = "end_at"
		case season
		case slug
		case winnerID = "winner_id"
		case winnerType = "winner_type"
		case year
	}
}
