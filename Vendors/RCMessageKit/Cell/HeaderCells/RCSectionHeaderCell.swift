class RCSectionHeaderCell: UITableViewCell {

	var labelSectionHeader: UILabel!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		backgroundColor = UIColor.clear

		if (labelSectionHeader == nil) {
			labelSectionHeader = UILabel()
			labelSectionHeader.font = RCMessages().sectionHeaderFont
			labelSectionHeader.textColor = RCMessages().sectionHeaderColor
			contentView.addSubview(labelSectionHeader)
		}

		labelSectionHeader.textAlignment = rcmessage.incoming ? .center : .center
		labelSectionHeader.text = messagesView.textSectionHeader(indexPath)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func layoutSubviews() {

		super.layoutSubviews()

		let widthTable = messagesView.tableView.frame.size.width

		let width: CGFloat = widthTable - RCMessages().sectionHeaderLeft - RCMessages().sectionHeaderRight
		let height: CGFloat = (labelSectionHeader.text != nil) ? RCMessages().sectionHeaderHeight : 0

		labelSectionHeader.frame = CGRect(x: RCMessages().sectionHeaderLeft, y: 0, width: width, height: height)
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc class func height(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGFloat {

		return (messagesView.textSectionHeader(indexPath) != nil) ? RCMessages().sectionHeaderHeight : 0
	}
}
