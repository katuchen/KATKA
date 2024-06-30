struct OpponentElement : Codable {
	let opponentType: String?
	let opponent: OpponentModel
	
	enum CodingKeys: String, CodingKey {
		case opponentType = "opponent_type"
		case opponent
	}
}
