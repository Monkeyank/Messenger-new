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
class RCLocationMessageCell: RCMessageCell {

	var imageViewX: UIImageView!
	var spinner: UIActivityIndicatorView!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		super.bindData(indexPath, messagesView: messagesView)

		viewBubble.backgroundColor = rcmessage.incoming ? RCMessages().locationBubbleColorIncoming : RCMessages().locationBubbleColorOutgoing

		if (imageViewX == nil) {
			imageViewX = UIImageView()
			imageViewX.layer.masksToBounds = true
			imageViewX.layer.cornerRadius = RCMessages().bubbleRadius
			viewBubble.addSubview(imageViewX)
		}

		if (spinner == nil) {
			spinner = UIActivityIndicatorView(style: .white)
			viewBubble.addSubview(spinner)
		}

		if (rcmessage.status == RC_STATUS_LOADING) {
			imageViewX.image = nil
			spinner.startAnimating()
		}

		if (rcmessage.status == RC_STATUS_SUCCEED) {
			imageViewX.image = rcmessage.location_thumbnail
			spinner.stopAnimating()
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func layoutSubviews() {

		let size = RCLocationMessageCell.size(indexPath, messagesView: messagesView)

		super.layoutSubviews(size)

		imageViewX.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

		let widthSpinner = spinner.frame.size.width
		let heightSpinner = spinner.frame.size.height
		let xSpinner = (size.width - widthSpinner) / 2
		let ySpinner = (size.height - heightSpinner) / 2
		spinner.frame = CGRect(x: xSpinner, y: ySpinner, width: widthSpinner, height: heightSpinner)
	}

	// MARK: - Size methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc class func height(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGFloat {

		let size = self.size(indexPath, messagesView: messagesView)
		return size.height
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func size(_ indexPath: IndexPath, messagesView: RCMessagesView) -> CGSize {

		return CGSize(width: RCMessages().locationBubbleWidth, height: RCMessages().locationBubbleHeight)
	}
}
