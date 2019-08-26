class Blocker: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(userId: String) {

		let object = FObject(path: FBLOCKER_PATH, subpath: userId)

		object[FBLOCKER_OBJECTID] = FUser.currentId()
		object[FBLOCKER_BLOCKERID] = FUser.currentId()
		object[FBLOCKER_ISDELETED] = false

		object.saveInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItem(userId: String) {

		let object = FObject(path: FBLOCKER_PATH, subpath: userId)

		object[FBLOCKER_OBJECTID] = FUser.currentId()
		object[FBLOCKER_BLOCKERID] = FUser.currentId()
		object[FBLOCKER_ISDELETED] = true

		object.updateInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func isBlocker(userId: String) -> Bool {

		let predicate = NSPredicate(format: "blockerId == %@ AND isDeleted == NO", userId)
		let dbblocker = DBBlocker.objects(with: predicate).firstObject() as? DBBlocker

		return (dbblocker != nil)
	}
}
