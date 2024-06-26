import SwiftUI

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
							let adjustedColor = UIColor(Color(uiImage.getDominantColor())).adjustBrightness()
							self.primaryColor = Color(adjustedColor)
						}
				} placeholder: {
					ProgressView()
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
					let adjustedColor = UIColor(Color(color1)).adjustBrightness()
					DispatchQueue.main.async {
						self.primaryColor = Color(adjustedColor)
					}
				}
			}
		}
		
		else {
			self.primaryColor = Color(.blue.opacity(0.3))
		}
	}
}
