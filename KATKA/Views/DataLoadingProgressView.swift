import SwiftUI

struct DataLoadingProgressView : View {
	var body: some View {
		ProgressView()
			.progressViewStyle(CircularProgressViewStyle())
			.cornerRadius(10)
			.frame(width: 100, height: 100)
	}
}
