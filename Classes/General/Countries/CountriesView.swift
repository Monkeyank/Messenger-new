@objc protocol CountriesDelegate: class {

	func didSelectCountry(name: String, code: String)
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class CountriesView: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var delegate: CountriesDelegate?

	@IBOutlet var tableView: UITableView!

	private var countries: [[String: String]] = []
	private var sections: [[[String: String]]] = []
	private let collation = UILocalizedIndexedCollation.current()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Countries"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))

		loadCountries()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadCountries() {

		let path = Dir.application("countries.plist")
		if let array = NSArray(contentsOfFile: path) as? [[String: String]] {
			countries = array
		}

		let selector: Selector = #selector(NSDictionary.name)
		sections = Array(repeating: [], count: collation.sectionTitles.count)

		if let sorted = collation.sortedArray(from: countries, collationStringSelector: selector) as? [[String: String]] {
			for country in sorted {
				let section = collation.section(for: country, collationStringSelector: selector)
				sections[section].append(country)
			}
		}
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		dismiss(animated: true)
	}

	// MARK: - Table view data source
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in tableView: UITableView) -> Int {

		return sections.count
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return sections[section].count
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		return (sections[section].count != 0) ? collation.sectionTitles[section] : nil
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {

		return collation.sectionIndexTitles
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

		return collation.section(forSectionIndexTitle: index)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")
		if (cell == nil) { cell = UITableViewCell(style: .default, reuseIdentifier: "cell") }

		let country = sections[indexPath.section][indexPath.row]
		cell.textLabel?.text = country["name"]

		return cell
	}

	// MARK: - Table view delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		let country = sections[indexPath.section][indexPath.row]

		if let name = country["name"] {
			if let code = country["dial_code"] {
				delegate?.didSelectCountry(name: name, code: code)
			}
		}

		dismiss(animated: true)
	}
}
