import SwiftUI

struct NoMatchesView: View {
	var body: some View {
		VStack {
			Text("There is no matches!")
				.font(.title)
				.bold()
			Text("Try changing filters, dates or just come back later.")
				.font(.subheadline)
		}
		.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .center)
		.padding(30)
		.multilineTextAlignment(.center)
		.foregroundStyle(Color(.label))
	}
}
