class DBBlocker: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var blockerId = ""
	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func lastUpdatedAt() -> Int64 {

		let dbblocker = DBBlocker.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBBlocker
		return dbblocker?.updatedAt ?? 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override static func primaryKey() -> String? {

		return FBLOCKER_OBJECTID
	}
}
