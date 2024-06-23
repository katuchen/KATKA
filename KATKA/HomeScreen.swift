import SwiftUI
import Foundation
import Combine

// Data Model

struct MatchModel : Identifiable, Codable {
	let beginAt, endAt: String?
	let detailedStats, draw: Bool?
	let forfeit: Bool?
	let id: Int
	let league: LeagueModel?
	let leagueID: Int?
	let matchType: String?
	let name: String?
	let numberOfGames: Int?
	let opponents: [OpponentElement]
	let results: [ResultsModel]?
	let serie: SeriesModel?
	let serieID: Int?
	let slug, status: String?
	let tournament: TournamentModel?
	let tournamentID: Int?
	let videogame: VideogameModel?
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
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case slug
	}
}

struct TournamentModel : Identifiable, Codable {
	let id : Int
	let name : String?
	let beginAt, endAt : String?
	let detailedStats : Bool?
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
	let opponent: OpponentModel
	
	enum CodingKeys: String, CodingKey {
		case opponentType = "opponent_type"
		case opponent
	}
}

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
	let playerID: Int?
	
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
	
	var cancellables = Set<AnyCancellable>()
	
	init() {
		getMatches()
	}
	func getMatches() {
		guard let url = URL(string: "https://api.pandascore.co/matches") else {
			print("URL ERROR")
			return
		}
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		let queryItems: [URLQueryItem] = [
			URLQueryItem(name: "range[begin_at]", value: "2024-06-23T00:00:00Z,2024-06-23T23:59:59Z"),
			//URLQueryItem(name: "sort", value: "begin_at"),
			URLQueryItem(name: "page", value: "1"),
			URLQueryItem(name: "per_page", value: "50"),
		]
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
		
		var request = URLRequest(url: components.url ?? url)
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
			.store(in: &cancellables)
	}
}

struct HomeScreen: View {
	@StateObject var vm = DataViewModel()
	
	var body: some View {
		ScrollView {
			VStack {
				ForEach(vm.matches) { match in
					let league = match.league
					let tournament = match.tournament
					let series = match.serie
					LeagueView(
						logoURL: league?.imageURL,
						leagueName: league?.name ?? "",
						tournamentName: tournament?.name ?? "",
						seriesName: series?.name ?? ""
					)
					MatchView(match: match)
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
					.frame(width: 20, height: 20)
			} placeholder: {
				Image(systemName: "circle.fill")
					.foregroundStyle(Color(.systemBlue))
					.frame(width: 20, height: 20)
			}
			.frame(width: 20, height: 20)
			Text("\(leagueName) \(tournamentName) \(seriesName)")
				.multilineTextAlignment(.leading)
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

struct MatchView : View {
	let match : MatchModel
	var body: some View {
		let opponentFirst = match.opponents.first?.opponent
		let opponentSecond = match.opponents.last?.opponent
		
		HStack {
			OpponentView(opponentName: opponentFirst?.name ?? "", logoURL: opponentFirst?.imageURL)
			Spacer()
			CentralInfoView(matchDate: match.beginAt ?? "Unknown", matchType: match.matchType ?? "", numberOfGames: match.numberOfGames ?? 0)
			Spacer()
			OpponentView(opponentName: opponentSecond?.name ?? "", logoURL: opponentSecond?.imageURL)
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.padding()
	}
}

struct OpponentView : View {
	let opponentName : String
	let logoURL : URL?
	var body: some View {
		VStack {
			AsyncImage(url: logoURL) { image in
				image
					.resizable()
					.scaledToFit()
					.frame(width: 50, height: 50, alignment: .leadingFirstTextBaseline)
			} placeholder: {
				Image(systemName: "gamecontroller.fill")
					.foregroundStyle(Color(.systemBlue))
					.frame(width: 50, height: 50)
			}
			Text(opponentName)
				.font(.title3)
				.fontWeight(.light)
				.foregroundStyle(.primary)
				.frame(maxWidth: 200)
		}
		.font(.title3)
		.fontWeight(.light)
		.multilineTextAlignment(.center)
	}
}

struct CentralInfoView : View {
	let matchDate : String
	let matchType : String
	let numberOfGames : Int
	
	var body: some View {
		VStack {
			Text("\(getDate(from: matchDate))")
			Text("\(getTime(from: matchDate))")
				.font(.title)
			Text("\(matchType)\(numberOfGames)")
		}
		.font(.subheadline)
	}
}

extension CentralInfoView {
	func getDate(from stringDate: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		formatter.timeZone = .gmt
		let realDate = formatter.date(from: stringDate)
		formatter.dateFormat = "MMM d"
		return formatter.string(from: realDate ?? Date())
	}
	
	func getTime(from stringDate: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		formatter.timeZone = .gmt
		let realDate = formatter.date(from: stringDate)
		formatter.dateFormat = "HH:mm"
		return formatter.string(from: realDate ?? Date())
	}
}

#Preview {
	HomeScreen()
}
