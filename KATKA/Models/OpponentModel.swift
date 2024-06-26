import SwiftUI

struct OpponentModel : Identifiable, Codable {
	let acronym: String?
	let currentVideogame: VideogameModel?
	let id: Int
	let imageURL: URL?
	let name: String?
	let players: [PlayerModel]?
	let slug: String?
	
	enum CodingKeys: String, CodingKey {
		case acronym
		case currentVideogame = "current_videogame"
		case id
		case imageURL = "image_url"
		case name
		case players
		case slug
	}
}
