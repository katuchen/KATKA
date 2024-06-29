import SwiftUI

struct CalendarView: View {
	@Binding var dateChosen : Date
	
	var body: some View {
		HStack {
			Image(systemName: "calendar.circle")
				.resizable()
				.frame(width: 30, height: 30)
				.foregroundStyle(Color(.label).opacity(0.8))
				.overlay(
					DatePicker("", selection: $dateChosen, displayedComponents: .date)
						.labelsHidden()
						.frame(width: 0, height: 0)
						.clipped()
						.contentShape(Rectangle())
				)
		}
	}
}
