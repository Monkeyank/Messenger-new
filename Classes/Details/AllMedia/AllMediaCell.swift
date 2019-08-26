class AllMediaCell: UICollectionViewCell {

	@IBOutlet var imageItem: UIImageView!
	@IBOutlet var imageVideo: UIImageView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(dbmessage: DBMessage) {

		imageItem.image = UIImage(named: "allmedia_blank")

		if (dbmessage.type == MESSAGE_PICTURE) {
			bindPicture(dbmessage: dbmessage)
		}
		if (dbmessage.type == MESSAGE_VIDEO) {
			bindVideo(dbmessage: dbmessage)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindPicture(dbmessage: DBMessage) {

		imageVideo.isHidden = true

		if let path = DownloadManager.pathImage(dbmessage.objectId) {
			if let image = UIImage(contentsOfFile: path) {
				imageItem.image = Image.square(image: image, size: 320)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindVideo(dbmessage: DBMessage) {

		imageVideo.isHidden = false

		if let path = DownloadManager.pathVideo(dbmessage.objectId) {
			DispatchQueue(label: "bindVideo").async {
				let image = Video.thumbnail(path: path)
				DispatchQueue.main.async {
					self.imageItem.image = Image.square(image: image, size: 320)
				}
			}
		}
	}
}
