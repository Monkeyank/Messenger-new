extension NSError {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func description(_ description: String, code: Int) -> Error? {

		let domain = Bundle.main.bundleIdentifier ?? ""
		let userInfo = [NSLocalizedDescriptionKey: description]
		return NSError(domain: domain, code: code, userInfo: userInfo)
	}
}
