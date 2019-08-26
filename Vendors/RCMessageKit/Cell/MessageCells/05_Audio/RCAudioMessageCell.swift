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
class RCAudioMessageCell: RCMessageCell {

	var imageStatus: UIImageView!
	var labelDuration: UILabel!
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

		viewBubble.backgroundColor = rcmessage.incoming ? RCMessages().audioBubbleColorIncoming : RCMessages().audioBubbleColorOutgoing

		if (imageStatus == nil) {
			imageStatus = UIImageView()
			viewBubble.addSubview(imageStatus)
		}

		if (labelDuration == nil) {
			labelDuration = UILabel()
			labelDuration.font = RCMessages().audioFont
			labelDuration.textAlignment = .right
			viewBubble.addSubview(labelDuration)
		}

		if (spinner == nil) {
			spinner = UIActivityIndicatorView(style: .white)
			viewBubble.addSubview(spinner)
		}

		if (imageManual == nil) {
			imageManual = UIImageView(image: RCMessages().audioImageManual)
			viewBubble.addSubview(imageManual)
		}

		if (rcmessage.audio_status == RC_AUDIOSTATUS_STOPPED) { imageStatus.image = RCMessages().audioImagePlay		}
		if (rcmessage.audio_status == RC_AUDIOSTATUS_PLAYING) { imageStatus.image = RCMessages().audioImagePause	}

		labelDuration.textColor = rcmessage.incoming ? RCMessages().audioTextColorIncoming : RCMessages().audioTextColorOutgoing

		if (rcmessage.audio_duration < 60) {
			labelDuration.text = String(format: "0:%02ld", rcmessage.audio_duration)
		} else {
			labelDuration.text = String(format: "%ld:%02ld", rcmessage.audio_duration / 60, rcmessage.audio_duration % 60)
		}

		if (rcmessage.status == RC_STATUS_LOADING) {
			imageStatus.isHidden = true
			labelDuration.isHidden = true
			spinner.startAnimating()
			imageManual.isHidden = true
		}

		if (rcmessage.status == RC_STATUS_SUCCEED) {
			imageStatus.isHidden = false
			labelDuration.isHidden = false
			spinner.stopAnimating()
			imageManual.isHidden = true
		}

		if (rcmessage.status == RC_STATUS_MANUAL) {
			imageStatus.isHidden = true
			labelDuration.isHidden = true
			spinner.stopAnimating()
			imageManual.isHidden = false
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc override func layoutSubviews() {

		let size = RCAudioMessageCell.size(indexPath, messagesView: messagesView)

		super.layoutSubviews(size)

		let widthStatus = imageStatus.image!.size.width
		let heightStatus = imageStatus.image!.size.height
		let yStatus = (size.height - heightStatus) / 2
		imageStatus.frame = CGRect(x: 10, y: yStatus, width: widthStatus, height: heightStatus)

		labelDuration.frame = CGRect(x: size.width - 100, y: 0, width: 90, height: size.height)

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

		return CGSize(width: RCMessages().audioBubbleWidht, height: RCMessages().audioBubbleHeight)
	}
}
