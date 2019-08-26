class RCBubbleFooterCell: UITableViewCell {

	var labelBubbleFooter: UILabel!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		backgroundColor = UIColor.clear

		if (labelBubbleFooter == nil) {
			labelBubbleFooter = UILabel()
			labelBubbleFooter.font = RCMessages().bubbleFooterFont
			labelBubbleFooter.textColor = RCMessages().bubbleFooterColor
			contentView.addSubview(labelBubbleFooter)
		}

		labelBubbleFooter.textAlignment = rcmessage.incoming ? .left : .right
		labelBubbleFooter.text = messagesView.textBubbleFooter(indexPath)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func layoutSubviews() {

		super.layoutSubviews()

		let widthTable = messagesView.tableView.frame.size.width

		let width: CGFloat = widthTable - RCMessages().bubbleFooterLeft - RCMessages().bubbleFooterRight
		let height: CGFloat = (labelBubbleFooter.text != nil) ? RCMessages().bubbleFooterHeight : 0

		labelBubbleFooter.frame = CGRect(x: RCMessages().bubbleFooterLeft, y: 0, width: width, height: height)
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc class func height(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGFloat {

		return (messagesView.textBubbleFooter(indexPath) != nil) ? RCMessages().bubbleFooterHeight : 0
	}
}
