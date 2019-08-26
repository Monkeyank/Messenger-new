class Group: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(name: String, members: [String], completion: @escaping (_ error: Error?) -> Void) {

		let linkeds = Convert.arrayToDict(members)

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_USERID] = FUser.currentId()
		object[FGROUP_NAME] = name
		object[FGROUP_MEMBERS] = members
		object[FGROUP_LINKEDS] = linkeds
		object[FGROUP_ISDELETED] = false

		object.saveInBackground(block: { error in
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updateName(groupId: String, name: String, completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_NAME] = name

		object.updateInBackground(block: { error in
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updateMembers(groupId: String, members: [String], linkeds: [String: Bool], completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_MEMBERS] = members
		object[FGROUP_LINKEDS] = linkeds

		object.updateInBackground(block: { error in
			completion(error)
		})
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func deleteItem(groupId: String, completion: @escaping (_ error: Error?) -> Void) {

		let object = FObject(path: FGROUP_PATH)

		object[FGROUP_OBJECTID] = groupId
		object[FGROUP_ISDELETED] = true

		object.updateInBackground(block: { error in
			completion(error)
		})
	}
}
