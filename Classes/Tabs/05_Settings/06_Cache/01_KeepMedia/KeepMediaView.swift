class KeepMediaView: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet var tableView: UITableView!
	@IBOutlet var cellWeek: UITableViewCell!
	@IBOutlet var cellMonth: UITableViewCell!
	@IBOutlet var cellForever: UITableViewCell!

	private var keepMedia: Int = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Keep Media"

		loadUser()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadUser() {

		keepMedia = FUser.keepMedia()
		updateDetails()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func saveUser() {

		let user = FUser.currentUser()
		user[FUSER_KEEPMEDIA] = keepMedia
		user.saveInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	// MARK: - Table view data source
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in tableView: UITableView) -> Int {

		return 1
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return 3
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if (indexPath.section == 0) && (indexPath.row == 0) { return cellWeek		}
		if (indexPath.section == 0) && (indexPath.row == 1) { return cellMonth		}
		if (indexPath.section == 0) && (indexPath.row == 2) { return cellForever	}

		return UITableViewCell()
	}

	// MARK: - Table view delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		if (indexPath.section == 0) && (indexPath.row == 0) { keepMedia = Int(KEEPMEDIA_WEEK)		}
		if (indexPath.section == 0) && (indexPath.row == 1) { keepMedia = Int(KEEPMEDIA_MONTH)		}
		if (indexPath.section == 0) && (indexPath.row == 2) { keepMedia = Int(KEEPMEDIA_FOREVER)	}

		updateDetails()
		saveUser()
	}

	// MARK: - Helper methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateDetails() {

		cellWeek.accessoryType = (keepMedia == KEEPMEDIA_WEEK) ? .checkmark : .none
		cellMonth.accessoryType = (keepMedia == KEEPMEDIA_MONTH) ? .checkmark : .none
		cellForever.accessoryType = (keepMedia == KEEPMEDIA_FOREVER) ? .checkmark : .none

		tableView.reloadData()
	}
}
