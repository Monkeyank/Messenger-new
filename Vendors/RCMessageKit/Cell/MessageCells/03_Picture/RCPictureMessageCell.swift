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
class RCPictureMessageCell: RCMessageCell {

	var imageViewX: UIImageView!
	var imageManual: UIImageView!
	var spinner: UIActivityIndicatorView!

	private var indexPath: IndexPath!
	private var messagesView: RCMessagesView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func bindData(_ indexPath_: IndexPath, messagesView messagesView_: RCMessagesView) {

		indexPath = indexPath_
		messagesView = messagesView_

		let rcmessage = messagesView.rcmessage(indexPath)

		super.bindData(indexPath, messagesView: messagesView)

		viewBubble.backgroundColor = rcmessage.incoming ? RCMessages().pictureBubbleColorIncoming : RCMessages().pictureBubbleColorOutgoing

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

		if (imageManual == nil) {
			imageManual = UIImageView(image: RCMessages().pictureImageManual)
			viewBubble.addSubview(imageManual)
		}

		if (rcmessage.status == RC_STATUS_LOADING) {
			imageViewX.image = nil
			spinner.startAnimating()
			imageManual.isHidden = true
		}

		if (rcmessage.status == RC_STATUS_SUCCEED) {
			imageViewX.image = rcmessage.picture_image
			spinner.stopAnimating()
			imageManual.isHidden = true
		}

		if (rcmessage.status == RC_STATUS_MANUAL) {
			imageViewX.image = nil
			spinner.stopAnimating()
			imageManual.isHidden = false
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func layoutSubviews() {

		let size = RCPictureMessageCell.size(indexPath, messagesView: messagesView)

		super.layoutSubviews(size)

		imageViewX.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

		let widthSpinner = spinner.frame.size.width
		let heightSpinner = spinner.frame.size.height
		let xSpinner = (size.width - widthSpinner) / 2
		let ySpinner = (size.height - heightSpinner) / 2
		spinner.frame = CGRect(x: xSpinner, y: ySpinner, width: widthSpinner, height: heightSpinner)

		let widthManual = imageManual.image!.size.width
		let heightManual = imageManual.image!.size.height
		let xManual = (size.width - widthManual) / 2
		let yManual = (size.height - heightManual) / 2
		imageManual.frame = CGRect(x: xManual, y: yManual, width: widthManual, height: heightManual)
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

		let picture_width = CGFloat(rcmessage.picture_width)
		let picture_height = CGFloat(rcmessage.picture_height)

		let width = CGFloat.minimum(RCMessages().pictureBubbleWidth, picture_width)
		return CGSize(width: width, height: picture_height * width / picture_width)
	}
}
