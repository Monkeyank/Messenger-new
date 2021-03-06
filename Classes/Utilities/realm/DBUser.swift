class DBUser: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var email = ""
	@objc dynamic var phone = ""

	@objc dynamic var firstname = ""
	@objc dynamic var lastname = ""
	@objc dynamic var fullname = ""
	@objc dynamic var country = ""
	@objc dynamic var location = ""
	@objc dynamic var status = ""

	@objc dynamic var keepMedia: Int = 0
	@objc dynamic var networkImage: Int = 0
	@objc dynamic var networkVideo: Int = 0
	@objc dynamic var networkAudio: Int = 0
	@objc dynamic var wallpaper = ""

	@objc dynamic var loginMethod = ""
	@objc dynamic var oneSignalId = ""

	@objc dynamic var lastActive: Int64 = 0
	@objc dynamic var lastTerminate: Int64 = 0

	@objc dynamic var pictureAt: Int64 = 0
	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func lastUpdatedAt() -> Int64 {

		let dbuser = DBUser.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBUser
		return dbuser?.updatedAt ?? 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func initials() -> String {

		let initial1 = (firstname.count != 0) ? firstname.prefix(1) : ""
		let initial2 = (lastname.count != 0) ? lastname.prefix(1) : ""

		return "\(initial1)\(initial2)"
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override static func primaryKey() -> String? {

		return FUSER_OBJECTID
	}
}
