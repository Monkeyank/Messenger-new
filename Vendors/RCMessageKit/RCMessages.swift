import AVFoundation
import CoreLocation
import MapKit
import UIKit

//-------------------------------------------------------------------------------------------------------------------------------------------------
@objc class RCMessages: NSObject {

	// Section
	//-----------------------------------------------------------------------------
	var sectionHeaderMargin: CGFloat		= 8.0

	var sectionHeaderHeight: CGFloat		= 20.0
	var sectionHeaderLeft: CGFloat			= 10.0
	var sectionHeaderRight: CGFloat			= 10.0

	var sectionHeaderColor: UIColor			= UIColor.lightGray
	var sectionHeaderFont: UIFont			= UIFont.systemFont(ofSize: 12)

	var sectionFooterHeight: CGFloat		= 15.0
	var sectionFooterLeft: CGFloat			= 10.0
	var sectionFooterRight: CGFloat			= 10.0

	var sectionFooterColor: UIColor			= UIColor.lightGray
	var sectionFooterFont: UIFont			= UIFont.systemFont(ofSize: 12)

	var sectionFooterMargin: CGFloat		= 8.0

	// Bubble
	//-----------------------------------------------------------------------------
	var bubbleHeaderHeight: CGFloat			= 15.0
	var bubbleHeaderLeft: CGFloat			= 50.0
	var bubbleHeaderRight: CGFloat			= 50.0
	var bubbleHeaderColor: UIColor			= UIColor.lightGray
	var bubbleHeaderFont: UIFont			= UIFont.systemFont(ofSize: 12)

	var bubbleMarginLeft: CGFloat			= 40.0
	var bubbleMarginRight: CGFloat			= 40.0
	var bubbleRadius: CGFloat				= 15.0

	var bubbleFooterHeight: CGFloat			= 15.0
	var bubbleFooterLeft: CGFloat			= 50.0
	var bubbleFooterRight: CGFloat			= 50.0
	var bubbleFooterColor: UIColor			= UIColor.lightGray
	var bubbleFooterFont: UIFont			= UIFont.systemFont(ofSize: 12)

	// Avatar
	//-----------------------------------------------------------------------------
	var avatarDiameter: CGFloat				= 30.0
	var avatarMarginLeft: CGFloat			= 5.0
	var avatarMarginRight: CGFloat			= 5.0

	var avatarBackColor: UIColor			= UIColor.groupTableViewBackground
	var avatarTextColor: UIColor			= UIColor.white

	var avatarFont: UIFont					= UIFont.systemFont(ofSize: 12)

	// Status cell
	//-----------------------------------------------------------------------------
	var statusBubbleRadius: CGFloat			= 10.0

	var statusBubbleColor: UIColor			= UIColor.lightText
	var statusTextColor: UIColor			= UIColor.white

	var statusFont: UIFont					= UIFont.systemFont(ofSize: 12, weight: .semibold)

	var statusInsetLeft: CGFloat			= 10.0
	var statusInsetRight: CGFloat			= 10.0
	var statusInsetTop: CGFloat				= 5.0
	var statusInsetBottom: CGFloat			= 5.0
	var statusInset: UIEdgeInsets			= UIEdgeInsets.init(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)

	// Text cell
	//-----------------------------------------------------------------------------
	var textBubbleWidthMin: CGFloat			= 45.0
	var textBubbleHeightMin: CGFloat		= 35.0

	var textBubbleColorOutgoing: UIColor	= UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
	var textBubbleColorIncoming: UIColor	= UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)
	var textTextColorOutgoing: UIColor		= UIColor.white
	var textTextColorIncoming: UIColor		= UIColor.black

	var textFont: UIFont					= UIFont.systemFont(ofSize: 16)

	var textInsetLeft: CGFloat				= 10.0
	var textInsetRight: CGFloat				= 10.0
	var textInsetTop: CGFloat				= 10.0
	var textInsetBottom: CGFloat			= 10.0
	var textInset: UIEdgeInsets				= UIEdgeInsets.init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

	// Emoji cell
	//-----------------------------------------------------------------------------
	var emojiBubbleWidthMin: CGFloat		= 45.0
	var emojiBubbleHeightMin: CGFloat		= 30.0

	var emojiBubbleColorOutgoing: UIColor	= UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
	var emojiBubbleColorIncoming: UIColor	= UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)

	var emojiFont: UIFont					= UIFont.systemFont(ofSize: 46)

	var emojiInsetLeft: CGFloat				= 10.0
	var emojiInsetRight: CGFloat			= 10.0
	var emojiInsetTop: CGFloat				= 10.0
	var emojiInsetBottom: CGFloat			= 10.0
	var emojiInset: UIEdgeInsets			= UIEdgeInsets.init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

	// Picture cell
	//-----------------------------------------------------------------------------
	var pictureBubbleWidth: CGFloat			= 200.0

	var pictureBubbleColorOutgoing: UIColor	= UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)
	var pictureBubbleColorIncoming: UIColor	= UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)

	var pictureImageManual: UIImage			= UIImage(named: "rcmessages_manual")!

	// Video cell
	//-----------------------------------------------------------------------------
	var videoBubbleWidth: CGFloat			= 200.0
	var videoBubbleHeight: CGFloat			= 145.0

	var videoBubbleColorOutgoing: UIColor	= UIColor.lightGray
	var videoBubbleColorIncoming: UIColor	= UIColor.lightGray

	var videoImagePlay: UIImage				= UIImage(named: "rcmessages_videoplay")!
	var videoImageManual: UIImage			= UIImage(named: "rcmessages_manual")!

	// Audio cell
	//-----------------------------------------------------------------------------
	var audioBubbleWidht: CGFloat			= 150.0
	var audioBubbleHeight: CGFloat			= 40.0

	var audioBubbleColorOutgoing: UIColor	= UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
	var audioBubbleColorIncoming: UIColor	= UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)
	var audioTextColorOutgoing: UIColor		= UIColor.white
	var audioTextColorIncoming: UIColor		= UIColor.black

	var audioImagePlay: UIImage				= UIImage(named: "rcmessages_audioplay")!
	var audioImagePause: UIImage			= UIImage(named: "rcmessages_audiopause")!
	var audioImageManual: UIImage			= UIImage(named: "rcmessages_manual")!

	var audioFont: UIFont					= UIFont.systemFont(ofSize: 16)

	// Location cell
	//-----------------------------------------------------------------------------
	var locationBubbleWidth: CGFloat		= 200.0
	var locationBubbleHeight: CGFloat		= 145.0

	var locationBubbleColorOutgoing: UIColor = UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)
	var locationBubbleColorIncoming: UIColor = UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)

	// Input view
	//-----------------------------------------------------------------------------
	var inputViewBackColor: UIColor			= UIColor.groupTableViewBackground
	var inputTextBackColor: UIColor			= UIColor.white
	var inputTextTextColor: UIColor			= UIColor.black

	var inputFont: UIFont					= UIFont.systemFont(ofSize: 17)

	var inputViewHeightMin: CGFloat			= 44.0
	var inputTextHeightMin: CGFloat			= 30.0
	var inputTextHeightMax: CGFloat			= 110.0

	var inputBorderWidth: CGFloat			= 1.0
	var inputBorderColor: CGColor			= UIColor.lightGray.cgColor

	var inputRadius: CGFloat				= 5.0

	var inputInsetLeft: CGFloat				= 7.0
	var inputInsetRight: CGFloat			= 7.0
	var inputInsetTop: CGFloat				= 5.0
	var inputInsetBottom: CGFloat			= 5.0
	var inputInset: UIEdgeInsets			= UIEdgeInsets.init(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: RCMessages = {
		let instance = RCMessages()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()
	}
}
