class DBFriend: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var friendId = ""
	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func lastUpdatedAt() -> Int64 {

		let dbfriend = DBFriend.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBFriend
		return dbfriend?.updatedAt ?? 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override static func primaryKey() -> String? {

		return FFRIEND_OBJECTID
	}
}
