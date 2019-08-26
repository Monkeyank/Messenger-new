class Dir: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func application() -> String {

		return Bundle.main.resourcePath!
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func application(_ component: String) -> String {

		var path = application()

		path = (path as NSString).appendingPathComponent(component)

		return path
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func application(_ component1: String, and component2: String) -> String {

		var path = application()

		path = (path as NSString).appendingPathComponent(component1)
		path = (path as NSString).appendingPathComponent(component2)

		return path
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func document() -> String {

		return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func document(_ component: String) -> String {

		var path = document()

		path = (path as NSString).appendingPathComponent(component)

		createIntermediate(path: path)

		return path
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func document(_ component1: String, and component2: String) -> String {

		var path = document()

		path = (path as NSString).appendingPathComponent(component1)
		path = (path as NSString).appendingPathComponent(component2)

		createIntermediate(path: path)

		return path
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func cache() -> String {

		return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func cache(_ component: String) -> String {

		var path = cache()

		path = (path as NSString).appendingPathComponent(component)

		createIntermediate(path: path)

		return path
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createIntermediate(path: String) {

		let directory = (path as NSString).deletingLastPathComponent
		if (exist(path: directory) == false) {
			create(directory: directory)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func create(directory: String) {

		try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func exist(path: String) -> Bool {

		return FileManager.default.fileExists(atPath: path)
	}
}
