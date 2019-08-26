extension Date {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func timestamp() -> Int64 {

		return Int64(self.timeIntervalSince1970 * 1000)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static func date(timestamp: Int64) -> Date {

		let interval = TimeInterval(TimeInterval(timestamp) / 1000)
		return Date(timeIntervalSince1970: interval)
	}
}
