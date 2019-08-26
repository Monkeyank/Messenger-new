class RealmManager: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func cleanupDatabase() {

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			realm.deleteAllObjects()
			try realm.commitWriteTransaction()
		} catch {
			ProgressHUD.showError("Realm commit error.")
		}
	}
}
