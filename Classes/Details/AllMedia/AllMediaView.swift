class AllMediaView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

	@IBOutlet var collectionView: UICollectionView!

	private var chatId = ""
	private var dbmessages_media: [DBMessage] = []

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(chatId chatId_: String) {

		super.init(nibName: nil, bundle: nil)

		chatId = chatId_
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "All Media"

		collectionView.register(UINib(nibName: "AllMediaCell", bundle: nil), forCellWithReuseIdentifier: "AllMediaCell")

		loadMedia()
	}

	// MARK: - Load methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadMedia() {

		let predicate = NSPredicate(format: "chatId == %@ AND isDeleted == NO", chatId)
		let dbmessages = DBMessage.objects(with: predicate).sortedResults(usingKeyPath: FMESSAGE_CREATEDAT, ascending: true)

		for i in 0..<dbmessages.count {
			let dbmessage = dbmessages[i] as! DBMessage

			if (dbmessage.type == MESSAGE_PICTURE) {
				if (DownloadManager.pathImage(dbmessage.objectId) != nil) {
					dbmessages_media.append(dbmessage)
				}
			}

			if (dbmessage.type == MESSAGE_VIDEO) {
				if (DownloadManager.pathVideo(dbmessage.objectId) != nil) {
					dbmessages_media.append(dbmessage)
				}
			}
		}

		collectionView.reloadData()
	}

	// MARK: - UICollectionViewDataSource
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in collectionView: UICollectionView) -> Int {

		return 1
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		return dbmessages_media.count
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllMediaCell", for: indexPath) as! AllMediaCell

		let dbmessage = dbmessages_media[indexPath.item]
		cell.bindData(dbmessage: dbmessage)

		return cell
	}

	// MARK: - UICollectionViewDelegateFlowLayout
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let screenWidth = UIScreen.main.bounds.size.width
		return CGSize(width: screenWidth/2, height: screenWidth/2)
	}

	// MARK: - UICollectionViewDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		collectionView.deselectItem(at: indexPath, animated: true)

		let dbmessage = dbmessages_media[indexPath.item]

		if (dbmessage.type == MESSAGE_PICTURE) {
			presentPicture(dbmessage: dbmessage)
		}
		if (dbmessage.type == MESSAGE_VIDEO) {
			presentVideo(dbmessage: dbmessage)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func presentPicture(dbmessage: DBMessage) {

		if (DownloadManager.pathImage(dbmessage.objectId) != nil) {
			let dictionary = PictureView.photos(messageId: dbmessage.objectId, chatId: chatId)
			if let photoItems = dictionary["photoItems"] as? [NYTPhoto] {
				if let initialPhoto = dictionary["initialPhoto"] as? NYTPhoto {
					let pictureView = PictureView(photos: photoItems, initialPhoto: initialPhoto)
					pictureView.setMessages(messages: true)
					present(pictureView, animated: true)
				}
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func presentVideo(dbmessage: DBMessage) {

		if let path = DownloadManager.pathVideo(dbmessage.objectId) {
			let url = URL(fileURLWithPath: path)
			let videoView = VideoView(url: url)
			present(videoView, animated: true)
		}
	}
}
