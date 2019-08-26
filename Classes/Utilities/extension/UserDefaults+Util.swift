extension UserDefaults {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func setObject(value: Any, key: String) {

		UserDefaults.standard.set(value, forKey: key)
		UserDefaults.standard.synchronize()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func removeObject(key: String) {

		UserDefaults.standard.removeObject(forKey: key)
		UserDefaults.standard.synchronize()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func string(key: String) -> String? {

		return UserDefaults.standard.string(forKey: key)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func bool(key: String) -> Bool {

		return UserDefaults.standard.bool(forKey: key)
	}
}
