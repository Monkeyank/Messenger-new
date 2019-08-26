class Blockers: NSObject {

	private var timer: Timer?
	private var refreshUIBlockers = false
	private var firebase: DatabaseReference?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: Blockers = {
		let instance = Blockers()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		NotificationCenter.addObserver(target: self, selector: #selector(initObservers), name: NOTIFICATION_APP_STARTED)
		NotificationCenter.addObserver(target: self, selector: #selector(initObservers), name: NOTIFICATION_USER_LOGGED_IN)
		NotificationCenter.addObserver(target: self, selector: #selector(actionCleanup), name: NOTIFICATION_USER_LOGGED_OUT)

		timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(refreshUserInterface), userInfo: nil, repeats: true)
	}

	// MARK: - Backend methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func initObservers() {

		if (FUser.currentId() != "") {
			if (firebase == nil) {
				createObservers()
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func createObservers() {

		let lastUpdatedAt = DBBlocker.lastUpdatedAt()

		firebase = Database.database().reference(withPath: FBLOCKER_PATH).child(FUser.currentId())
		let query = firebase?.queryOrdered(byChild: FBLOCKER_UPDATEDAT).queryStarting(atValue: lastUpdatedAt + 1)

		query?.observe(DataEventType.childAdded, with: { snapshot in
			if let blocker = snapshot.value as? [String: Any] {
				if (blocker[FBLOCKER_CREATEDAT] as? Int64 != nil) {
					DispatchQueue(label: "Blockers").async {
						self.updateRealm(blocker: blocker)
						self.refreshUIBlockers = true
					}
				}
			}
		})

		query?.observe(DataEventType.childChanged, with: { snapshot in
			if let blocker = snapshot.value as? [String: Any] {
				if (blocker[FBLOCKER_CREATEDAT] as? Int64 != nil) {
					DispatchQueue(label: "Blockers").async {
						self.updateRealm(blocker: blocker)
						self.refreshUIBlockers = true
					}
				}
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateRealm(blocker: [String: Any]) {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			DBBlocker.createOrUpdate(in: realm, withValue: blocker)
			try realm.commitWriteTransaction()
		} catch {
			ProgressHUD.showError("Realm commit error.")
		}
	}

	// MARK: - Cleanup methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCleanup() {

		firebase?.removeAllObservers()
		firebase = nil
	}

	// MARK: - Notification methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func refreshUserInterface() {

		if (refreshUIBlockers) {
			NotificationCenter.post(notification: NOTIFICATION_REFRESH_BLOCKERS)
			refreshUIBlockers = false
		}
	}
}
