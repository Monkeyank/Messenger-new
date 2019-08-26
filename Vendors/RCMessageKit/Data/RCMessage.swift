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

import CoreLocation
import MapKit

//-------------------------------------------------------------------------------------------------------------------------------------------------
@objc class RCMessage: NSObject {

	var type: Int = 0

	var incoming = false
	var outgoing = false

	var text = ""

	var picture_image: UIImage?
	var picture_width: Int = 0
	var picture_height: Int = 0

	var video_path = ""
	var video_thumbnail: UIImage?
	var video_duration: Int = 0

	var audio_path = ""
	var audio_duration: Int = 0
	var audio_status: Int = 0

	var latitude: CLLocationDegrees = 0
	var longitude: CLLocationDegrees = 0
	var location_thumbnail: UIImage?

	var status: Int = 0

	// MARK: - Initialization methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {
		
		super.init()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(text: String, incoming incoming_: Bool) {

		super.init()

		type = Int(RC_TYPE_TEXT)

		incoming = incoming_
		outgoing = !incoming

		self.text = text
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(emoji text: String, incoming incoming_: Bool) {

		super.init()

		type = Int(RC_TYPE_EMOJI)

		incoming = incoming_
		outgoing = !incoming

		self.text = text
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(picture image: UIImage?, width: Int, height: Int, incoming incoming_: Bool) {

		super.init()

		type = Int(RC_TYPE_PICTURE)

		incoming = incoming_
		outgoing = !incoming

		picture_image = image
		picture_width = width
		picture_height = height
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(video path: String?, duration: Int, incoming incoming_: Bool) {

		super.init()

		type = Int(RC_TYPE_VIDEO)

		incoming = incoming_
		outgoing = !incoming

		video_path = path ?? ""
		video_duration = duration
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(audio path: String?, duration: Int, incoming incoming_: Bool) {

		super.init()

		type = Int(RC_TYPE_AUDIO)

		incoming = incoming_
		outgoing = !incoming

		audio_path = path ?? ""
		audio_duration = duration
		audio_status = Int(RC_AUDIOSTATUS_STOPPED)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, incoming incoming_: Bool, completion: @escaping () -> Void) {

		super.init()

		type = Int(RC_TYPE_LOCATION)

		incoming = incoming_
		outgoing = !incoming

		self.latitude = latitude
		self.longitude = longitude

		status = Int(RC_STATUS_LOADING)

		var region: MKCoordinateRegion = MKCoordinateRegion()
		region.center.latitude = self.latitude
		region.center.longitude = self.longitude
		region.span.latitudeDelta = CLLocationDegrees(0.005)
		region.span.longitudeDelta = CLLocationDegrees(0.005)

		let options = MKMapSnapshotter.Options()
		options.region = region
		options.size = CGSize(width: RCMessages().locationBubbleWidth, height: RCMessages().locationBubbleHeight)
		options.scale = UIScreen.main.scale

		let snapshotter = MKMapSnapshotter(options: options)
		snapshotter.start(with: DispatchQueue.global(qos: .default), completionHandler: { snapshot, error in
			if (snapshot != nil) {
				DispatchQueue.main.async {
					UIGraphicsBeginImageContextWithOptions(snapshot!.image.size, true, snapshot!.image.scale)
					do {
						snapshot!.image.draw(at: CGPoint.zero)
						let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
						var point = snapshot!.point(for: CLLocationCoordinate2DMake(self.latitude, self.longitude))
						point.x += pin.centerOffset.x - (pin.bounds.size.width / 2)
						point.y += pin.centerOffset.y - (pin.bounds.size.height / 2)
						pin.image!.draw(at: point)
						self.location_thumbnail = UIGraphicsGetImageFromCurrentImageContext()
					}
					UIGraphicsEndImageContext()
					self.status = Int(RC_STATUS_SUCCEED)
					completion()
				}
			}
		})
	}
}
