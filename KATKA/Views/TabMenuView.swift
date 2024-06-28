import SwiftUI
import UIKit

struct TabMenuView: View {
	var body: some View {
		TabView {
			HomeScreen()
			.tabItem {
				Label(
					title: { Text("Home") },
					icon: { Image(systemName: "heart.fill") }
				)
			}
		}
	}
}
