class DBMessage: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var chatId = ""
	@objc dynamic var members = ""

	@objc dynamic var senderId = ""
	@objc dynamic var senderFullname = ""
	@objc dynamic var senderInitials = ""
	@objc dynamic var senderPictureAt: Int64 = 0

	@objc dynamic var recipientId = ""
	@objc dynamic var recipientFullname = ""
	@objc dynamic var recipientInitials = ""
	@objc dynamic var recipientPictureAt: Int64 = 0

	@objc dynamic var groupId = ""
	@objc dynamic var groupName = ""

	@objc dynamic var type = ""
	@objc dynamic var text = ""

	@objc dynamic var pictureWidth: Int = 0
	@objc dynamic var pictureHeight: Int = 0
	@objc dynamic var videoDuration: Int = 0
	@objc dynamic var audioDuration: Int = 0

	@objc dynamic var latitude: CLLocationDegrees = 0
	@objc dynamic var longitude: CLLocationDegrees = 0

	@objc dynamic var status = ""
	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func lastUpdatedAt() -> Int64 {

		let dbmessage = DBMessage.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBMessage
		return dbmessage?.updatedAt ?? 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override static func primaryKey() -> String? {

		return FMESSAGE_OBJECTID
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateItem(status status_: String) {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			status = status_
			try realm.commitWriteTransaction()
		} catch {
			ProgressHUD.showError("Realm commit error.")
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateItem(isDeleted isDeleted_: Bool) {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			isDeleted = isDeleted_
			try realm.commitWriteTransaction()
		} catch {
			ProgressHUD.showError("Realm commit error.")
		}
	}
}
