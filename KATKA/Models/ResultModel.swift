import SwiftUI

struct ResultsModel : Codable {
	let score: Int?
	let teamID: Int?
	let playerID: Int?
	
	enum CodingKeys: String, CodingKey {
		case score
		case teamID = "team_id"
		case playerID = "player_id"
	}
}
