class MediaView: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet var tableView: UITableView!
	@IBOutlet var cellImage: UITableViewCell!
	@IBOutlet var cellVideo: UITableViewCell!
	@IBOutlet var cellAudio: UITableViewCell!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Media Settings"

		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		loadUser()
	}

	// MARK: - Backend methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadUser() {

		updateCell(selectedNetwork: FUser.networkImage(), cell: cellImage)
		updateCell(selectedNetwork: FUser.networkVideo(), cell: cellVideo)
		updateCell(selectedNetwork: FUser.networkAudio(), cell: cellAudio)

		tableView.reloadData()
	}

	// MARK: - Helper methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateCell(selectedNetwork: Int, cell: UITableViewCell) {

		if (selectedNetwork == NETWORK_MANUAL)	{ cell.detailTextLabel?.text = "Manual"				}
		if (selectedNetwork == NETWORK_WIFI)	{ cell.detailTextLabel?.text = "Wi-Fi"				}
		if (selectedNetwork == NETWORK_ALL)		{ cell.detailTextLabel?.text = "Wi-Fi + Cellular"	}
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func actionNetwork(mediaType: Int) {

		let networkView = NetworkView(mediaType: mediaType)
		navigationController?.pushViewController(networkView, animated: true)
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

		if (indexPath.section == 0) && (indexPath.row == 0) { return cellImage		}
		if (indexPath.section == 0) && (indexPath.row == 1) { return cellVideo		}
		if (indexPath.section == 0) && (indexPath.row == 2) { return cellAudio		}

		return UITableViewCell()
	}

	// MARK: - Table view delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		if (indexPath.section == 0) && (indexPath.row == 0) { actionNetwork(mediaType: Int(MEDIA_IMAGE))	}
		if (indexPath.section == 0) && (indexPath.row == 1) { actionNetwork(mediaType: Int(MEDIA_VIDEO))	}
		if (indexPath.section == 0) && (indexPath.row == 2) { actionNetwork(mediaType: Int(MEDIA_AUDIO))	}
	}
}
