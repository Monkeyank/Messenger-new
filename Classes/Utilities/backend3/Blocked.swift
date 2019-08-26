class Blocked: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(userId: String) {

		let object = FObject(path: FBLOCKED_PATH, subpath: FUser.currentId())

		object[FBLOCKED_OBJECTID] = userId
		object[FBLOCKED_BLOCKEDID] = userId
		object[FBLOCKED_ISDELETED] = false

		object.saveInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItem(userId: String) {

		let object = FObject(path: FBLOCKED_PATH, subpath: FUser.currentId())

		object[FBLOCKED_OBJECTID] = userId
		object[FBLOCKED_BLOCKEDID] = userId
		object[FBLOCKED_ISDELETED] = true

		object.updateInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func isBlocked(userId: String) -> Bool {

		let predicate = NSPredicate(format: "blockedId == %@ AND isDeleted == NO", userId)
		let dbblocked = DBBlocked.objects(with: predicate).firstObject() as? DBBlocked

		return (dbblocked != nil)
	}
}
