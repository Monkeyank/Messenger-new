class Connectivity: NSObject {

	var reachability: Reachability?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: Connectivity = {
		let instance = Connectivity()
		return instance
	} ()

	// MARK: - Reachability methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func isReachable() -> Bool {

		return shared.reachability?.isReachable() ?? false
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func isReachableViaWWAN() -> Bool {

		return shared.reachability?.isReachableViaWWAN() ?? false
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func isReachableViaWiFi() -> Bool {

		return shared.reachability?.isReachableViaWiFi() ?? false
	}

	// MARK: - Instance methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		reachability = Reachability(hostname: "www.google.com")
		reachability?.startNotifier()

		let notification = NSNotification.Name.reachabilityChanged
		NotificationCenter.addObserver(target: self, selector: #selector(reachabilityChanged(_:)), name: notification.rawValue)
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func reachabilityChanged(_ notification: Notification?) {

	}
}
