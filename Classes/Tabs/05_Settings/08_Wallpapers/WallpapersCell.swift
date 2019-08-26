class WallpapersCell: UICollectionViewCell {

	@IBOutlet var imageItem: UIImageView!
	@IBOutlet var imageSelected: UIImageView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(path: String) {

		imageItem.image = UIImage(named: path)
		imageSelected.isHidden = (FUser.wallpaper() != path)
	}
}
