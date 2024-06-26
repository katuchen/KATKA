import SwiftUI

struct LeagueModel : Identifiable, Codable {
	let id: Int
	let imageURL: URL?
	let name: String?
	let slug: String?
	let url: URL?
	
	enum CodingKeys: String, CodingKey {
		case id
		case imageURL = "image_url"
		case name
		case slug
		case url
	}
}
