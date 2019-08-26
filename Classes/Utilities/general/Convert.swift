class Convert: NSObject {

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func arrayToString(_ array_: [String]?) -> String {

		if let array = array_ {
			return arrayToString(array: array)
		}
		return ""
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func arrayToString(array: [String]) -> String {

		if (array.count != 0) {
			return array.joined(separator: ",")
		}
		return ""
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func dictToString(_ dictionary_: [String: Bool]?) -> String {

		if let dictionary = dictionary_ {
			return dictToString(dictionary: dictionary)
		}
		return ""
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func dictToString(dictionary: [String: Bool]) -> String {

		let array = Array(dictionary.keys)
		return arrayToString(array: array)
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func stringToArray(_ string: String) -> [String] {

		if (string.count != 0) {
			return string.components(separatedBy: ",")
		}
		return []
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func stringToDict(_ string: String) -> [String: Bool] {

		let array = stringToArray(string)
		return arrayToDict(array)
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func arrayToDict(_ array: [String], _ value: Bool = true) -> [String: Bool] {

		var dictionary: [String: Bool] = [:]
		for key in array {
			dictionary[key] = value
		}
		return dictionary
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func dictToJson(_ dictionary_: [String: Int64]?) -> String {

		if let dictionary = dictionary_ {
			return dictToJson(dictionary: dictionary)
		}
		return ""
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func dictToJson(dictionary: [String: Int64]) -> String {

		if let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
			if let string = String(data: data, encoding: .utf8) {
				return string
			}
		}
		return ""
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func jsonToDict(_ string: String) -> [String: Int64] {

		if let jsonObject = try? JSONSerialization.jsonObject(with: Data(string.utf8), options: []) {
			if let dictionary = jsonObject as? [String: Int64] {
				return dictionary
			}
		}
		return [:]
	}

	// MARK: -
	//-------------------------------------------------------------------------------------------------------------------------------------------------
	class func dateToShort(_ date: Date) -> String {

		return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------------
	class func timestampToMediumTime(_ timestamp: Int64) -> String {

		let date = Date.date(timestamp: timestamp)
		return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
	}

	//-------------------------------------------------------------------------------------------------------------------------------------------------
	class func timestampToDayMonthTime(_ timestamp: Int64) -> String {

		let date = Date.date(timestamp: timestamp)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd MMMM, HH:mm"
		return dateFormatter.string(from: date)
	}

	// MARK: -
	//-------------------------------------------------------------------------------------------------------------------------------------------------
	class func timestampToElapsed(_ timestamp: Int64) -> String {

		var elapsed = ""

		let date = Date.date(timestamp: timestamp)
		let seconds = Date().timeIntervalSince(date)

		if (seconds < 60) {
			elapsed = "Just now"
		} else if (seconds < 60 * 60) {
			let minutes = Int(seconds / 60)
			let text = (minutes > 1) ? "mins" : "min"
			elapsed = "\(minutes) \(text)"
		} else if (seconds < 24 * 60 * 60) {
			let hours = Int(seconds / (60 * 60))
			let text = (hours > 1) ? "hours" : "hour"
			elapsed = "\(hours) \(text)"
		} else if (seconds < 7 * 24 * 60 * 60) {
			let formatter = DateFormatter()
			formatter.dateFormat = "EEEE"
			elapsed = formatter.string(from: date)
		} else {
			elapsed = dateToShort(date)
		}

		return elapsed
	}
}
