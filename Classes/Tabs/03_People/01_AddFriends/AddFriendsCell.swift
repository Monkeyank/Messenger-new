class AddFriendsCell: UITableViewCell {

	@IBOutlet var imageUser: UIImageView!
	@IBOutlet var labelInitials: UILabel!
	@IBOutlet var labelName: UILabel!
	@IBOutlet var labelStatus: UILabel!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(dbuser: DBUser) {

		labelName.text = dbuser.fullname
		labelStatus.text = dbuser.status
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadImage(dbuser: DBUser, tableView: UITableView, indexPath: IndexPath) {

		if let path = DownloadManager.pathUser(dbuser.objectId) {
			imageUser.image = UIImage(contentsOfFile: path)
			labelInitials.text = nil
		} else {
			imageUser.image = UIImage(named: "addfriends_blank")
			labelInitials.text = dbuser.initials()
			downloadImage(dbuser: dbuser, tableView: tableView, indexPath: indexPath)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func downloadImage(dbuser: DBUser, tableView: UITableView, indexPath: IndexPath) {

		DownloadManager.startUser(dbuser.objectId, pictureAt: dbuser.pictureAt) { path, error in
			let indexSelf = tableView.indexPath(for: self)
			if ((indexSelf == nil) || (indexSelf == indexPath)) {
				if (error == nil) {
					self.imageUser.image = UIImage(contentsOfFile: path!)
					self.labelInitials.text = nil
				} else if (error!.code() == 102) {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						self.downloadImage(dbuser: dbuser, tableView: tableView, indexPath: indexPath)
					}
				}
			}
		}
	}
}
