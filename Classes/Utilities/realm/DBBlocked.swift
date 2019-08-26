class DBBlocked: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var blockedId = ""
	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func lastUpdatedAt() -> Int64 {

		let dbblocked = DBBlocked.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBBlocked
		return dbblocked?.updatedAt ?? 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override static func primaryKey() -> String? {

		return FBLOCKED_OBJECTID
	}
}
