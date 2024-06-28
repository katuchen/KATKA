import SwiftUI

struct TimeLineView: View {
	@Binding var dateSelected: Date
	
	var body: some View {
		HStack (spacing: 20) {
			TimeLineButtonView(label: "Yesterday", isChosen: dateSelected.isSameDay(as: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()))
				.onTapGesture {
					withAnimation(.smooth) {
						dateSelected = changeSelectedDate(to: -1)
					}
				}
			TimeLineButtonView(label: "Today", isChosen: dateSelected.isSameDay(as: Date()))
				.onTapGesture {
					withAnimation(.smooth) {
						dateSelected = Date()
					}
				}
			TimeLineButtonView(label: "Tomorrow", isChosen: dateSelected.isSameDay(as: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()))
				.onTapGesture {
					withAnimation(.smooth) {
						dateSelected = changeSelectedDate(to: 1)
						
					}
				}
		}
	}
}

struct TimeLineButtonView: View {
	let label: String
	var isChosen: Bool
	
	var body: some View {
		Text(label)
			.foregroundColor(isChosen ? Color(.label) : Color(.secondaryLabel))
			.bold()
			.padding(.vertical, 10)
			.padding(.horizontal, 10)
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(isChosen ? Color(.systemBlue) : Color(.secondarySystemFill))
			)
	}
}

extension TimeLineView {
	func changeSelectedDate(to numberOfDays: Int) -> Date {
		return Calendar.current.date(byAdding: .day, value: numberOfDays, to: Date()) ?? Date()
	}
}

extension Date {
	func isSameDay(as otherDate: Date) -> Bool {
		let calendar = Calendar.current
		return calendar.isDate(self, inSameDayAs: otherDate)
	}
}
