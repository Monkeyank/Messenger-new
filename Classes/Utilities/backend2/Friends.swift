class Friends: NSObject {

	private var timer: Timer?
	private var refreshUIFriends = false
	private var firebase: DatabaseReference?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: Friends = {
		let instance = Friends()
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

		let lastUpdatedAt = DBFriend.lastUpdatedAt()

		firebase = Database.database().reference(withPath: FFRIEND_PATH).child(FUser.currentId())
		let query = firebase?.queryOrdered(byChild: FFRIEND_UPDATEDAT).queryStarting(atValue: lastUpdatedAt + 1)

		query?.observe(DataEventType.childAdded, with: { snapshot in
			if let friend = snapshot.value as? [String: Any] {
				if (friend[FFRIEND_CREATEDAT] as? Int64 != nil) {
					DispatchQueue(label: "Friends").async {
						self.updateRealm(friend: friend)
						self.refreshUIFriends = true
					}
				}
			}
		})

		query?.observe(DataEventType.childChanged, with: { snapshot in
			if let friend = snapshot.value as? [String: Any] {
				if (friend[FFRIEND_CREATEDAT] as? Int64 != nil) {
					DispatchQueue(label: "Friends").async {
						self.updateRealm(friend: friend)
						self.refreshUIFriends = true
					}
				}
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateRealm(friend: [String: Any]) {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			DBFriend.createOrUpdate(in: realm, withValue: friend)
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

		if (refreshUIFriends) {
			NotificationCenter.post(notification: NOTIFICATION_REFRESH_FRIENDS)
			refreshUIFriends = false
		}
	}
}
