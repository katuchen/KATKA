import SwiftUI

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
			Text(league)
				.font(.footnote)
				.bold()
				.foregroundStyle(Color(.secondaryLabel))
				.lineLimit(1)
			
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
					.bold()
			} else if status == "running" {
				HStack (spacing: 5) {
					Text("LIVE")
						.font(.title2)
				}
			} else {
				Text("\(getTime(from: matchRealDate))")
					.font(.title)
					.bold()
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
extension Color {
	static let ui = Color.UI()
	
	struct UI {
		let electricGreen = Color("ElectricGreen")
	}
}
