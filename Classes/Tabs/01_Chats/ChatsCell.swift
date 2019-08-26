class ChatsCell: MGSwipeTableCell {

	@IBOutlet var imageUser: UIImageView!
	@IBOutlet var labelInitials: UILabel!
	@IBOutlet var labelDetails: UILabel!
	@IBOutlet var labelLastMessage: UILabel!
	@IBOutlet var labelElapsed: UILabel!
	@IBOutlet var imageMuted: UIImageView!
	@IBOutlet var viewUnread: UIView!
	@IBOutlet var labelUnread: UILabel!
	
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(dbchat: DBChat) {

		labelDetails.text = dbchat.details
		labelLastMessage.text = dbchat.lastMessageText

		let typings = Convert.jsonToDict(dbchat.typings)
		for typing in Array(typings.values) {
			if (typing == 1) { labelLastMessage.text = "Typing..." }
		}

		labelElapsed.text = Convert.timestampToElapsed(dbchat.lastMessageDate)

		imageMuted.isHidden = dbchat.mutedUntil < Date().timestamp()
		viewUnread.isHidden = (dbchat.counter == 0)
		labelUnread.text = "\(min(dbchat.counter, 99))"
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadImage(dbchat: DBChat, tableView: UITableView, indexPath: IndexPath) {

		if (dbchat.recipientId.count != 0) {
			if let path = DownloadManager.pathUser(dbchat.recipientId) {
				imageUser.image = UIImage(contentsOfFile: path)
				labelInitials.text = nil
			} else {
				imageUser.image = UIImage(named: "chats_blank")
				labelInitials.text = dbchat.recipientInitials
				downloadImage(dbchat: dbchat, tableView: tableView, indexPath: indexPath)
			}
		}

		if (dbchat.groupId.count != 0) {
			imageUser.image = UIImage(named: "chats_blank")
			labelInitials.text = String(dbchat.groupName.prefix(1))
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func downloadImage(dbchat: DBChat, tableView: UITableView, indexPath: IndexPath) {

		DownloadManager.startUser(dbchat.recipientId, pictureAt: dbchat.recipientPictureAt) { path, error in
			let indexSelf = tableView.indexPath(for: self)
			if ((indexSelf == nil) || (indexSelf == indexPath)) {
				if (error == nil) {
					self.imageUser.image = UIImage(contentsOfFile: path!)
					self.labelInitials.text = nil
				} else if (error!.code() == 102) {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						self.downloadImage(dbchat: dbchat, tableView: tableView, indexPath: indexPath)
					}
				}
			}
		}
	}
}
