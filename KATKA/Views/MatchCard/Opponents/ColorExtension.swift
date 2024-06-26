import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

extension Image {
	func asUIImage() -> UIImage {
		let controller = UIHostingController(rootView: self.resizable())
		let view = controller.view
		
		let targetSize = controller.view.intrinsicContentSize
		view?.bounds = CGRect(origin: .zero, size: targetSize)
		view?.backgroundColor = .clear
		
		let format = UIGraphicsImageRendererFormat()
		format.scale = 1
		let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
		
		return renderer.image { _ in
			view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
		}
	}
}

extension UIImage {
	func getDominantColor() -> UIColor {
		let defaultColor : UIColor = UIColor(red: 0, green: 0, blue: 100, alpha: 1)
		guard let inputImage = CIImage(image: self) else { return defaultColor }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
		
		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return defaultColor }
		guard let outputImage = filter.outputImage else { return defaultColor }
		
		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
		
		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}
}

extension UIColor {
	func getHSBComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return (hue, saturation, brightness, alpha)
	}
	
	func adjustBrightness() -> UIColor {
		let hsb = self.getHSBComponents()
		let brightnessThreshold: CGFloat = 0.6
		if hsb.brightness > brightnessThreshold || hsb.brightness < 0.4 {
			return UIColor(hue: hsb.hue, saturation: hsb.saturation, brightness: brightnessThreshold, alpha: hsb.alpha)
		}
		
		return self
	}
}
