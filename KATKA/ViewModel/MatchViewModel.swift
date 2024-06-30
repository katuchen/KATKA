import SwiftUI
import Foundation
import Combine

class MatchViewModel: ObservableObject {
	@Published var matches: [MatchModel] = []
	@Published var leagues: [LeagueModel] = []
	@Published var isLoading = false
	@Published var dateSelected: Date = Date() {
		didSet { getMatches() }
	}
	
	static let allGames = VideogameModel.GameSlug.allCases.map { $0.rawValue }.joined(separator: ",")
	
	@Published var gameSelected: String = allGames {
		didSet { getMatches() }
	}
	
	var cancellables = Set<AnyCancellable>()
	
	init() {
		getMatches()
		getLeagues()
	}
	
	func getMatches() {
		fetchData(
			endpoint: "matches",
			queryItems: [
				URLQueryItem(name: "filter[videogame]", value: gameSelected),
				URLQueryItem(name: "range[begin_at]", value: getDatesForFilter(date: dateSelected)),
				URLQueryItem(name: "sort", value: "-status,begin_at"),
				URLQueryItem(name: "page", value: "1"),
				URLQueryItem(name: "per_page", value: "50")
			]
		) { [weak self] (result: Result<[MatchModel], Error>) in
			switch result {
				case .success(let data):
					self?.matches = data
					self?.isLoading = false
				case .failure(let error):
					print("Error: \(error)")
			}
		}
	}
	
	func getLeagues() {
		fetchData(
			endpoint: "leagues",
			queryItems: [
				URLQueryItem(name: "page", value: "1"),
				URLQueryItem(name: "per_page", value: "50")
			]
		) { [weak self] (result: Result<[LeagueModel], Error>) in
			switch result {
				case .success(let data):
					self?.leagues = data
				case .failure(let error):
					print("Error: \(error)")
			}
		}
	}
	
	private func fetchData<T: Decodable>(endpoint: String, queryItems: [URLQueryItem], completion: @escaping (Result<T, Error>) -> Void) {
		isLoading = true
		guard let url = URL(string: "https://api.pandascore.co/\(endpoint)"),
			  let token = ProcessInfo.processInfo.environment["TOKEN"] else {
			print("URL or TOKEN ERROR")
			return
		}
		
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
		components.queryItems = queryItems
		
		var request = URLRequest(url: components.url!)
		request.httpMethod = "GET"
		request.timeoutInterval = 10
		request.setValue("application/json", forHTTPHeaderField: "accept")
		request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
		
		URLSession.shared.dataTaskPublisher(for: request)
			.subscribe(on: DispatchQueue.global(qos: .background))
			.receive(on: DispatchQueue.main)
			.tryMap { output in
				guard let response = output.response as? HTTPURLResponse,
					  response.statusCode >= 200 && response.statusCode < 300 else { throw URLError(.badServerResponse) }
				return output.data
			}
			.decode(type: T.self, decoder: JSONDecoder())
			.sink(receiveCompletion: { completionResult in
				if case .failure(let error) = completionResult {
					completion(.failure(error))
				}
			}, receiveValue: { data in
				completion(.success(data))
			})
			.store(in: &cancellables)
	}
	
	func getDatesForFilter(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.timeZone = .gmt
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		
		let startOfDay = Calendar.current.startOfDay(for: date)
		let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
		let endOfDay = Calendar.current.date(byAdding: .second, value: -1, to: nextDay)!
		
		return "\(formatter.string(from: startOfDay))Z,\(formatter.string(from: endOfDay))Z"
	}
}
