import SwiftUI

struct TeamModel : Identifiable, Codable {
	let id: Int
	let name: String?
	let acronym: String?
	let imageURL: URL?
	let location: String?
	let slug: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case acronym
		case imageURL = "image_url"
		case location
		case slug
	}
}

enum WinnerType : String {
	case team = "Team"
	case player = "Player"
}
