import SwiftUI

struct VideogameModel : Codable {
	enum id : Int, CaseIterable {
		case cs = 3
		case dota = 4
		case leagueOfLegends = 1
		case valorant = 26
		case codMW = 23
		case fifa = 25
		case kog = 27
		case lolWildRift = 28
		case mlbb = 34
		case overwatch = 14
		case pubg = 20
		case r6Siege = 24
		case rocketLeague = 22
		case starcraft2 = 29
		case starcraftBW = 30
	}
	enum name : String, CaseIterable {
		case cs = "Counter-Strike"
		case dota = "Dota 2"
		case leagueOfLegends = "LoL"
		case valorant = "Valorant"
		case codMW = "Call of Duty"
		case fifa = "EA Sports FC 24"
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
	enum slug: String, CaseIterable {
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
	let leagues : [LeagueModel]?
	let url: URL?
	
	enum CodingKeys: String, CodingKey {
		case leagues
		case url
	}
}
