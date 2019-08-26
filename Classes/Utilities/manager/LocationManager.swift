class LocationManager: NSObject, CLLocationManagerDelegate {

	var locationManager: CLLocationManager?
	var coordinate = CLLocationCoordinate2D()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: LocationManager = {
		let instance = LocationManager()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func start() {

		shared.locationManager?.startUpdatingLocation()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func stop() {

		shared.locationManager?.stopUpdatingLocation()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func latitude() -> CLLocationDegrees {

		return shared.coordinate.latitude
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func longitude() -> CLLocationDegrees {

		return shared.coordinate.longitude
	}

	// MARK: - Instance methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		locationManager?.requestWhenInUseAuthorization()
	}

	// MARK: - CLLocationManagerDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		if let location = locations.last {
			coordinate = location.coordinate
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

	}
}
