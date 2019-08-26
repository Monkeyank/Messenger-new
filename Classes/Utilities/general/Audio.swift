class Audio: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func duration(path: String) -> Int {

		let asset = AVURLAsset(url: URL(fileURLWithPath: path), options: nil)
		return Int(round(CMTimeGetSeconds(asset.duration)))
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func playMessageIncoming() {

		let path = Dir.application("rcmessage_incoming.aiff")
		RCAudioPlayer.shared.playSound(path)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func playMessageOutgoing() {

		let path = Dir.application("rcmessage_outgoing.aiff")
		RCAudioPlayer.shared.playSound(path)
	}
}
