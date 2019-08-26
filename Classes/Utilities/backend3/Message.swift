class Message: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItem(dbmessage: DBMessage) {

		if (dbmessage.status == TEXT_SENT) {
			deleteItemSent(dbmessage: dbmessage)
		}
		if (dbmessage.status == TEXT_QUEUED) {
			deleteItemQueued(dbmessage: dbmessage)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItemSent(dbmessage: DBMessage) {

		let object = FObject(path: FMESSAGE_PATH, subpath: FUser.currentId())

		object[FMESSAGE_OBJECTID] = dbmessage.objectId
		object[FMESSAGE_ISDELETED] = true

		object.updateInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItemQueued(dbmessage: DBMessage) {

		dbmessage.updateItem(isDeleted: true)

		NotificationCenter.post(notification: NOTIFICATION_REFRESH_MESSAGES1)
	}
}
