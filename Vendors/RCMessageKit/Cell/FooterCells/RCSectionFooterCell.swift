class RCSectionFooterCell: UITableViewCell {

	var labelSectionFooter: UILabel!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		backgroundColor = UIColor.clear

		if (labelSectionFooter == nil) {
			labelSectionFooter = UILabel()
			labelSectionFooter.font = RCMessages().sectionFooterFont
			labelSectionFooter.textColor = RCMessages().sectionFooterColor
			contentView.addSubview(labelSectionFooter)
		}

		labelSectionFooter.textAlignment = rcmessage.incoming ? .left : .right
		labelSectionFooter.text = messagesView.textSectionFooter(indexPath)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func layoutSubviews() {

		super.layoutSubviews()

		let widthTable = messagesView.tableView.frame.size.width

		let width: CGFloat = widthTable - RCMessages().sectionFooterLeft - RCMessages().sectionFooterRight
		let height: CGFloat = (labelSectionFooter.text != nil) ? RCMessages().sectionFooterHeight : 0

		labelSectionFooter.frame = CGRect(x: RCMessages().sectionFooterLeft, y: 0, width: width, height: height)
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc class func height(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGFloat {

		return (messagesView.textSectionFooter(indexPath) != nil) ? RCMessages().sectionFooterHeight : 0
	}
}
