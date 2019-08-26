class CustomStatusView: UIViewController {

	@IBOutlet var fieldStatus: UITextField!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Custom status"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(actionSave))

		loadUser()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidAppear(_ animated: Bool) {

		super.viewDidAppear(animated)
		fieldStatus.becomeFirstResponder()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)
		view.endEditing(true)
	}

	// MARK: - Backend actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadUser() {

		fieldStatus.text = FUser.status()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func saveUser() {

		let user = FUser.currentUser()
		user[FUSER_STATUS] = fieldStatus.text
		user.saveInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionSave() {

		saveUser()
		dismiss(animated: true)
	}
}
