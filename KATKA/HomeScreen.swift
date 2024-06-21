import SwiftUI
import Foundation
import Combine

// Data Model

struct MatchModel : Identifiable, Codable {
	let beginAt, endAt: String?
	let detailedStats, draw: Bool?
	let forfeit: Bool?
	let id: Int
	let league: LeagueModel
	let leagueID: Int?
	let matchType: String?
	let name: String?
	let numberOfGames: Int?
	let opponents: [OpponentElement]?
	let results: [ResultsModel]?
	let serie: SeriesModel?
	let serieID: Int?
	let slug, status: String?
	let tournament: TournamentModel?
	let tournamentID: Int?
	let videogame: VideogameModel?
	let videogameVersion : String?
	let winnerID: Int?
	let winnerType: String?
	enum CodingKeys: String, CodingKey {
		case beginAt = "begin_at"
		case endAt = "end_at"
		case detailedStats = "detailed_stats"
		case draw
		case forfeit
		case id
		case league
		case leagueID = "league_id"
		case matchType = "match_type"
		case name
		case numberOfGames = "number_of_games"
		case opponents
		case results
		case serie
		case serieID = "serie_id"
		case slug
		case status
		case tournament
		case tournamentID = "tournament_id"
		case videogame
		case videogameVersion = "videogame_version"
		case winnerID = "winner_id"
		case winnerType = "winner_type"
	}
}

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

struct VideogameModel : Identifiable, Codable {
	let id: Int
	let name, slug: String?
	let currentVersion: String?
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case slug
		case currentVersion = "current_version"
	}
}

struct TournamentModel : Identifiable, Codable {
	let id : Int
	let name : String?
	let beginAt, endAt : String?
	let detailedStats : Bool
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

struct OpponentElement : Codable {
	let opponentType: String?
	let opponents: [OpponentModel]?
	
	enum CodingKeys: String, CodingKey {
		case opponentType = "opponent_type"
		case opponents
	}
}

struct OpponentModel : Identifiable, Codable {
	let acronym: String?
	let currentVideogame: VideogameModel?
	let id: Int
	let imageURL: String?
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

struct ResultsModel : Codable {
	let score: Int?
	let teamID: Int?
	let playerID: String?
	
	enum CodingKeys: String, CodingKey {
		case score
		case teamID = "team_id"
		case playerID = "player_id"
	}
}

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

class DataViewModel : ObservableObject {
	@Published var matches : [MatchModel] = []
	
	init() {
		getData()
	}
	func getData() {
		let url = URL(string: "https://api.pandascore.co/matches")!
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.timeoutInterval = 10
		request.allHTTPHeaderFields = [
			"accept": "application/json",
			"authorization": "Bearer KpufEefVottDMcR4pDhBsIN-OVUAUyDx2FfII2wRkAizE9K_He8"
		]
		
		URLSession.shared.dataTaskPublisher(for: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.receive(on: DispatchQueue.main)
			.tryMap { output in
				guard let response = output.response as? HTTPURLResponse,
					  response.statusCode >= 200 && response.statusCode < 300 else { throw URLError(.badServerResponse)}
				return output.data
			}
			.decode(type: [MatchModel].self, decoder: JSONDecoder())
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished: print("Finished fetching data")
					case .failure(let error): print("Error: \(error)")
				}
			}, receiveValue: { [weak self] returnedData in
				self?.matches = returnedData
			})
		
	}
}

struct HomeScreen: View {
	@StateObject var vm = DataViewModel()
	
	var body: some View {
		ScrollView {
			VStack {
				ForEach(vm.matches) {match in
					LeagueView(logoURL: match.league.imageURL, leagueName: match.league.name ?? "", tournamentName: match.tournament?.name ?? "", seriesName: match.serie?.fullName ?? "")
				}
			}
		}
	}
}

struct LeagueView : View {
	let logoURL : URL?
	let leagueName : String
	let tournamentName : String
	let seriesName : String
	
	var body: some View {
		HStack {
			AsyncImage(url: logoURL) { image in
				image
					.resizable()
					.scaledToFit()
					.frame(width: 20, height: 20, alignment: .leadingFirstTextBaseline)
			} placeholder: {
				Image(systemName: "circle.fill")
					.foregroundStyle(Color(.systemBlue))
					.frame(width: 20, height: 20)
			}
			.frame(width: 20, height: 20)
			Text("\(leagueName) \(tournamentName) \(seriesName)")
				.multilineTextAlignment(.center)
		}
		.padding()
		.font(.subheadline)
		.fontWeight(.semibold)
		.foregroundStyle(.primary)
		.frame(maxWidth: .infinity, alignment: .center)
		.background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
		.shadow(color: Color(.secondarySystemBackground), radius: 10)
		.padding()
	}
}

#Preview {
	HomeScreen()
}
