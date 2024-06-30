struct PlayerModel : Identifiable, Codable {
	let id: Int
	let name: String?
	let firstName, lastName: String?
	let active: Bool?
	let age: Int?
	let birthday : String?
	let imageURL: String?
	let role, slug: String?
	
	enum CodingKeys: String, CodingKey {
		case active
		case age
		case birthday
		case firstName = "first_name"
		case id
		case imageURL = "image_url"
		case lastName = "last_name"
		case name
		case role
		case slug
	}
}
