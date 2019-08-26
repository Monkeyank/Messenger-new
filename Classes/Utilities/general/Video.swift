class Video: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func thumbnail(path: String) -> UIImage {

		let asset = AVURLAsset(url: URL(fileURLWithPath: path), options: nil)
		let generator = AVAssetImageGenerator(asset: asset)
		generator.appliesPreferredTrackTransform = true

		var time: CMTime = asset.duration
		time.value = CMTimeValue(0)
		var actualTime = CMTimeMake(value: 0, timescale: 0)

		if let cgImage = try? generator.copyCGImage(at: time, actualTime: &actualTime) {
			return UIImage(cgImage: cgImage)
		}

		return UIImage()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func duration(path: String) -> Int {

		let asset = AVURLAsset(url: URL(fileURLWithPath: path), options: nil)
		return Int(round(CMTimeGetSeconds(asset.duration)))
	}
}
