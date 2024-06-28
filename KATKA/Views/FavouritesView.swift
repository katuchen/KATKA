import SwiftUI

struct FavouritesView: View {
    var body: some View {
		NavigationStack {
		ZStack {
			backGround
				
			}
		.navigationTitle("Following")
		}
	}
}

extension FavouritesView {
	var backGround : some View {
		return RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)).opacity(0.8), .black], center: .top, startRadius: 1, endRadius: 400).ignoresSafeArea()
	}
}

#Preview {
    FavouritesView()
}
