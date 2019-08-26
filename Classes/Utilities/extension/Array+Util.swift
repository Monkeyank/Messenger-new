extension Array where Element: Hashable {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	mutating func removeDuplicates() {

		var array: [Element] = []

		for element in self {
			if !array.contains(element) {
				array.append(element)
			}
		}

		self = array
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	mutating func removeObject(_ element: Element) {

		var array = self

		while let index = array.firstIndex(of: element) {
			array.remove(at: index)
		}

		self = array
	}
}
