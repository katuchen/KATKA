import SwiftUI

struct ProfileView: View {
    var body: some View {
		NavigationStack {
		ZStack {
			backGround
			}
		.navigationTitle("Profile")
		}
	}
}

extension ProfileView {
	var backGround : some View {
		return RadialGradient(colors: [Color(uiColor: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)).opacity(0.8), .black], center: .top, startRadius: 1, endRadius: 400).ignoresSafeArea()
	}
}
#Preview {
    ProfileView()
}
