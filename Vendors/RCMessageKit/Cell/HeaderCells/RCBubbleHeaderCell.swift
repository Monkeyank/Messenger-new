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
class RCBubbleHeaderCell: UITableViewCell {

	var labelBubbleHeader: UILabel!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		backgroundColor = UIColor.clear

		if (labelBubbleHeader == nil) {
			labelBubbleHeader = UILabel()
			labelBubbleHeader.font = RCMessages().bubbleHeaderFont
			labelBubbleHeader.textColor = RCMessages().bubbleHeaderColor
			contentView.addSubview(labelBubbleHeader)
		}

		labelBubbleHeader.textAlignment = rcmessage.incoming ? .left : .right
		labelBubbleHeader.text = messagesView.textBubbleHeader(indexPath)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func layoutSubviews() {

		super.layoutSubviews()

		let widthTable = messagesView.tableView.frame.size.width

		let width: CGFloat = widthTable - RCMessages().bubbleHeaderLeft - RCMessages().bubbleHeaderRight
		let height: CGFloat = (labelBubbleHeader.text != nil) ? RCMessages().bubbleHeaderHeight : 0

		labelBubbleHeader.frame = CGRect(x: RCMessages().bubbleHeaderLeft, y: 0, width: width, height: height)
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc class func height(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGFloat {

		return (messagesView.textBubbleHeader(indexPath) != nil) ? RCMessages().bubbleHeaderHeight : 0
	}
}
