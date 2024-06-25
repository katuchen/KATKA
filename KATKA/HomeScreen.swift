import SwiftUI
import Foundation
import Combine
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

// MARK: Data Model

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

// MARK: Logo Color Extensions

extension UIImage {
	func getDominantColor() -> UIColor {
		let defaultColor : UIColor = UIColor(red: 0, green: 0, blue: 100, alpha: 1)
		guard let inputImage = CIImage(image: self) else { return defaultColor }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
		
		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return defaultColor }
		guard let outputImage = filter.outputImage else { return defaultColor }
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
		
		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
}

extension UIColor {
	func getHSBComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return (hue, saturation, brightness, alpha)
	}
	
	func adjustedForBrightness() -> UIColor {
		let hsb = self.getHSBComponents()
		let brightnessThreshold: CGFloat = 0.55
		if hsb.brightness > brightnessThreshold {
			return UIColor(hue: hsb.hue, saturation: hsb.saturation, brightness: brightnessThreshold, alpha: hsb.alpha)
		}
		return self
	}
}

// MARK: View Model

class DataViewModel : ObservableObject {
	@Published var matches : [MatchModel] = []
	@Published var dateSelected : Date = Date() {
		didSet {
			getMatches()
		}
	}
	
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
			URLQueryItem(name: "sort", value: "-tier"),
			URLQueryItem(name: "range[begin_at]",
						 value: "\(getDatesForFilter(date: dateSelected))"),
			URLQueryItem(name: "sort", value: "begin_at"),
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
	func getDatesForFilter(date : Date) -> String {
		let formatter = DateFormatter()
		//formatter.timeZone = .gmt
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		let startOfDay = Calendar.current.startOfDay(for: date)
		let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
		var datesString = ""
		datesString = formatter.string(from: startOfDay) + "Z," + formatter.string(from: endOfDay ?? startOfDay)
		print(datesString)
		return datesString
	}
}

// MARK: Views

struct HomeScreen: View {
	@StateObject var vm = DataViewModel()
	
	var body: some View {
		ZStack {
			RadialGradient(colors: [.blue.opacity(0.8), .black], center: .top, startRadius: 1, endRadius: 400).ignoresSafeArea()
			VStack {
				TimeLine(dateSelected: $vm.dateSelected)
				ScrollViewReader { proxy in
					ScrollView {
						LazyVStack(spacing: 10) {
							ForEach(vm.matches) { match in
								LazyVStack(spacing: 0) {
									MatchView(match: match)
								}
								.padding(.horizontal, 20)
							}
						}
					}
				}
			}
		}
	}
}

struct TimeLine: View {
	@Binding var dateSelected: Date
	
	var body: some View {
		HStack (spacing: 20) {
			TimeLineButton(label: "Yesterday", isChosen: dateSelected.isSameDay(as: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()))
				.onTapGesture {
					dateSelected = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
				}
			TimeLineButton(label: "Today", isChosen: dateSelected.isSameDay(as: Date()))
				.onTapGesture {
					dateSelected = Date()
				}
			TimeLineButton(label: "Tomorrow", isChosen: dateSelected.isSameDay(as: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()))
				.onTapGesture {
					dateSelected = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
				}
		}
	}
}

extension Date {
	func isSameDay(as otherDate: Date) -> Bool {
		let calendar = Calendar.current
		return calendar.isDate(self, inSameDayAs: otherDate)
	}
}


struct TimeLineButton: View {
	let label: String
	var isChosen: Bool
	
	var body: some View {
		Text(label)
			.foregroundColor(isChosen ? Color(.label) : Color(.secondaryLabel))
			.padding(.vertical, 10)
			.padding(.horizontal, 10)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(isChosen ? Color(.systemBlue) : Color(.secondarySystemFill))
			)
	}
}


struct LeagueView : View {
	let match : MatchModel
	
	var body: some View {
		let leagueName = match.league?.name
		let tournamentName = match.tournament?.name
		let seriesName = match.serie?.name
		let logoURL = match.league?.imageURL
		//		AsyncImage(url: logoURL) { image in
		//			image
		//				.resizable()
		//				.scaledToFit()
		//				.frame(width: 20, height: 20)
		//		} placeholder: {
		//			Image(systemName: "circle.fill")
		//				.foregroundStyle(Color(.systemBlue))
		//				.frame(width: 20, height: 20)
		//		}
		//		.frame(width: 20, height: 20)
		VStack {
			Text("\(leagueName ?? "")")
				.font(.subheadline)
				.foregroundStyle(Color(.label))
				.bold()
			Text("\(seriesName ?? "") \(tournamentName ?? "")")
		}
		.font(.caption)
		.foregroundStyle(Color(.secondaryLabel))
		.multilineTextAlignment(.center)
		.lineLimit(1)
		.padding()
	}
}

struct MatchView : View {
	let match : MatchModel
	@State private var primaryColor1: Color = .clear
	@State private var primaryColor2: Color = .clear
	
	var body: some View {
		let opponentFirst = match.opponents.first?.opponent
		let opponentSecond = match.opponents.last?.opponent
		HStack {
			OpponentView(
				opponentName: opponentFirst?.name ?? "",
				logoURL: opponentFirst?.imageURL,
				primaryColor: $primaryColor1
			)
			Spacer()
			CentralInfoView(
				league: match.league?.name ?? "",
				matchDate: match.beginAt ?? "Unknown",
				matchType: match.matchType ?? "",
				numberOfGames: match.numberOfGames ?? 0,
				status: match.status ?? "",
				results: match.results ?? []
			)
			Spacer()
			OpponentView(
				opponentName: opponentSecond?.name ?? "",
				logoURL: opponentSecond?.imageURL,
				primaryColor: $primaryColor2
			)
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 10)
				.fill(LinearGradient(gradient: Gradient(
					colors: [primaryColor1, primaryColor2]),
									 startPoint: .bottomLeading,
									 endPoint: .bottomTrailing)))
		.padding(.vertical, 10)
	}
}

struct OpponentView: View {
	@State var isTruncated: Bool = false
	let opponentName: String
	let logoURL: URL?
	@Binding var primaryColor: Color
	
	var body: some View {
		VStack {
			if let logoURL = logoURL {
				AsyncImage(url: logoURL) { image in
					image
						.resizable()
						.scaledToFit()
						.frame(width: 50, height: 50, alignment: .center)
						.onAppear {
							let uiImage = image.asUIImage()
							let adjustedColor = UIColor(Color(uiImage.getDominantColor())).adjustedForBrightness()
							self.primaryColor = Color(adjustedColor)
						}
				} placeholder: {
					Image(systemName: "gamecontroller.fill")
						.foregroundStyle(Color(.systemBlue))
						.frame(width: 50, height: 50)
				}
			} else {
				Image(systemName: "gamecontroller.fill")
					.foregroundStyle(Color(.systemBlue))
					.frame(width: 50, height: 50)
			}
			Text(opponentName)
				.font(.caption)
				.fontWeight(.light)
				.foregroundStyle(Color(.label))
				.padding(.horizontal, 10)
				.frame(maxWidth: 200)
		}
		.font(.title3)
		.fontWeight(.light)
		.lineLimit(1)
		.multilineTextAlignment(.center)
		.onAppear {
			loadPrimaryColors()
		}
	}
	
	func loadPrimaryColors() {
		if let logoURL = logoURL {
			DispatchQueue.global().async {
				if let data = try? Data(contentsOf: logoURL),
				   let image = UIImage(data: data) {
					let color1 = image.getDominantColor()
					let adjustedColor = UIColor(Color(color1)).adjustedForBrightness()
					DispatchQueue.main.async {
						self.primaryColor = Color(adjustedColor)
					}
				}
			}
		}
	}
}

extension Image {
	func asUIImage() -> UIImage {
		let controller = UIHostingController(rootView: self.resizable())
		let view = controller.view
		
		let targetSize = controller.view.intrinsicContentSize
		view?.bounds = CGRect(origin: .zero, size: targetSize)
		view?.backgroundColor = .clear
		
		let format = UIGraphicsImageRendererFormat()
		format.scale = 1
		let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
		
		return renderer.image { _ in
			view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
		}
	}
}

struct CentralInfoView : View {
	let league : String
	let matchDate: String
	let matchType: String
	let numberOfGames: Int
	let status: String
	let results: [ResultsModel]
	
	var body: some View {
		let matchRealDate = getRealDate(stringDate: matchDate)
		
		VStack {
			if !Calendar.current.isDateInToday(matchRealDate) {
				Text("\(getDate(from: matchRealDate))")
					.font(.subheadline)
					.foregroundStyle(Color(.secondaryLabel))
			}
			
			if status == "finished" {
				let resultFirst = results.first?.score
				let resultSecond = results.last?.score
				Text("\(resultFirst ?? 000) - \(resultSecond ?? 000)")
					.font(.title)
			} else {
				Text("\(getTime(from: matchRealDate))")
					.font(.title)
			}
			
			Text("\(matchType == "best_of" ? "BO" : "")\(numberOfGames)")
				.font(.subheadline)
				.foregroundStyle(Color(.secondaryLabel))
		}
	}
}

extension CentralInfoView {
	
	func getRealDate(stringDate: String) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		formatter.timeZone = .gmt
		let realDate = formatter.date(from: stringDate)
		return realDate ?? Date()
	}
	
	func getDate(from date: Date, formatter : DateFormatter = DateFormatter()) -> String {
		formatter.dateFormat = "MMM d"
		return formatter.string(from: date)
	}
	
	func getTime(from date: Date, formatter : DateFormatter = DateFormatter()) -> String {
		formatter.dateFormat = "HH:mm"
		return formatter.string(from: date)
	}
}

#Preview {
	HomeScreen()
}
