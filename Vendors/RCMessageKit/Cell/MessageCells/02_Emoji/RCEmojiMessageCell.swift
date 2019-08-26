//
// Copyright (c) 2018 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//-------------------------------------------------------------------------------------------------------------------------------------------------
class RCEmojiMessageCell: RCMessageCell {

	var textView: UITextView!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		super.bindData(indexPath, messagesView: messagesView)

		viewBubble.backgroundColor = rcmessage.incoming ? RCMessages().emojiBubbleColorIncoming : RCMessages().emojiBubbleColorOutgoing

		if (textView == nil) {
			textView = UITextView()
			textView.font = RCMessages().emojiFont
			textView.isEditable = false
			textView.isSelectable = false
			textView.isScrollEnabled = false
			textView.isUserInteractionEnabled = false
			textView.backgroundColor = UIColor.clear
			textView.textContainer.lineFragmentPadding = 0
			textView.textContainerInset = RCMessages().emojiInset
			viewBubble.addSubview(textView)
		}

		textView.text = rcmessage.text
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func layoutSubviews() {

		let size = RCEmojiMessageCell.size(indexPath, messagesView: messagesView)

		super.layoutSubviews(size)

		textView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc class func height(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGFloat {
		
		let size = self.size(indexPath, messagesView: messagesView)
		return size.height
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func size(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGSize {

		let rcmessage = messagesView.rcmessage(indexPath)

		let widthTable = messagesView.tableView.frame.size.width

		let maxwidth = (0.6 * widthTable) - RCMessages().emojiInsetLeft - RCMessages().emojiInsetRight

		let rect = rcmessage.text.boundingRect(with: CGSize(width: maxwidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: RCMessages().emojiFont], context: nil)

		let width = rect.size.width + RCMessages().emojiInsetLeft + RCMessages().emojiInsetRight
		let height = rect.size.height + RCMessages().emojiInsetTop + RCMessages().emojiInsetBottom

		return CGSize(width: CGFloat.maximum(width, RCMessages().emojiBubbleWidthMin), height: CGFloat.maximum(height, RCMessages().emojiBubbleHeightMin))
	}
}
