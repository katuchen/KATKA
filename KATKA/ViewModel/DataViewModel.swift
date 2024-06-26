import SwiftUI
import Foundation
import Combine

class DataViewModel : ObservableObject {
	@Published var matches : [MatchModel] = []
	@Published var dateSelected : Date = Date() {
		didSet {
			getMatches()
		}
	}
	
	static let allGames = VideogameModel.slug.allCases.map{ $0.rawValue }.joined(separator: ",")
	
	@Published var gameSelected : String = allGames {
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
			URLQueryItem(name: "filter[videogame]", value: gameSelected),
			URLQueryItem(name: "sort", value: "-tier"),
			URLQueryItem(name: "range[begin_at]", value: "\(getDatesForFilter(date: dateSelected))"),
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
		formatter.timeZone = .gmt
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		
		let startOfDay = Calendar.current.startOfDay(for: date)
		let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
		var datesString = ""
		
		datesString = formatter.string(from: startOfDay) + "Z," + formatter.string(from: endOfDay ?? startOfDay)
		print("For dates: \(datesString)")
		return datesString
	}
}
