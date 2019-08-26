class Friend: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(userId: String) {

		let object = FObject(path: FFRIEND_PATH, subpath: FUser.currentId())

		object[FFRIEND_OBJECTID] = userId
		object[FFRIEND_FRIENDID] = userId
		object[FFRIEND_ISDELETED] = false

		object.saveInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItem(userId: String) {

		let object = FObject(path: FFRIEND_PATH, subpath: FUser.currentId())

		object[FFRIEND_OBJECTID] = userId
		object[FFRIEND_ISDELETED] = true

		object.updateInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func isFriend(userId: String) -> Bool {

		let predicate = NSPredicate(format: "friendId == %@ AND isDeleted == NO", userId)
		let dbfriend = DBFriend.objects(with: predicate).firstObject() as? DBFriend

		return (dbfriend != nil)
	}
}
