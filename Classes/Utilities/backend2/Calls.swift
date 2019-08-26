class Calls: NSObject {

	private var timer: Timer?
	private var refreshUICalls = false
	private var firebase: DatabaseReference?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: Calls = {
		let instance = Calls()
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

		let lastUpdatedAt = DBCall.lastUpdatedAt()

		firebase = Database.database().reference(withPath: FCALL_PATH).child(FUser.currentId())
		let query = firebase?.queryOrdered(byChild: FCALL_UPDATEDAT).queryStarting(atValue: lastUpdatedAt + 1)

		query?.observe(DataEventType.childAdded, with: { snapshot in
			if let call = snapshot.value as? [String: Any] {
				if (call[FCALL_CREATEDAT] as? Int64 != nil) {
					DispatchQueue(label: "Calls").async {
						self.updateRealm(call: call)
						self.refreshUICalls = true
					}
				}
			}
		})

		query?.observe(DataEventType.childChanged, with: { snapshot in
			if let call = snapshot.value as? [String: Any] {
				if (call[FCALL_CREATEDAT] as? Int64 != nil) {
					DispatchQueue(label: "Calls").async {
						self.updateRealm(call: call)
						self.refreshUICalls = true
					}
				}
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateRealm(call: [String: Any]) {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			DBCall.createOrUpdate(in: realm, withValue: call)
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

		if (refreshUICalls) {
			NotificationCenter.post(notification: NOTIFICATION_REFRESH_CALLS)
			refreshUICalls = false
		}
	}
}
