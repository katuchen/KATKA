import SwiftUI

struct VideogameModel: Identifiable, Codable {
	let id: Int
	let name: GameName
	let slug: GameSlug
	let leagues: [LeagueModel]?
	let url: URL?
	
	enum GameName: String, Codable, CaseIterable {
		case cs = "Counter-Strike"
		case dota = "Dota 2"
		case leagueOfLegends = "LoL"
		case valorant = "Valorant"
		case codMW = "Call of Duty"
		case fifa = "EA Sports FC"
		case kog = "King of Glory"
		case lolWildRift = "LoL Wild Rift"
		case mlbb = "Mobile Legends: Bang Bang"
		case overwatch = "Overwatch"
		case pubg = "PUBG"
		case r6Siege = "Rainbow 6 Siege"
		case rocketLeague = "Rocket League"
		case starcraft2 = "StarCraft 2"
		case starcraftBW = "StarCraft Brood War"
	}
	
	enum GameSlug: String, Codable, CaseIterable {
		case cs = "cs-go"
		case dota = "dota-2"
		case leagueOfLegends = "league-of-legends"
		case valorant = "valorant"
		case codMW = "cod-mw"
		case fifa = "fifa"
		case kog = "kog"
		case lolWildRift = "lol-wild-rift"
		case mlbb = "mlbb"
		case overwatch = "ow"
		case pubg = "pubg"
		case r6Siege = "r6-siege"
		case rocketLeague = "rl"
		case starcraft2 = "starcraft-2"
		case starcraftBW = "starcraft-brood-war"
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case slug
		case leagues
		case url
	}
}
