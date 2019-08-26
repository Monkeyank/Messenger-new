class PasswordView: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

	@IBOutlet var tableView: UITableView!
	@IBOutlet var cellPassword0: UITableViewCell!
	@IBOutlet var cellPassword1: UITableViewCell!
	@IBOutlet var cellPassword2: UITableViewCell!
	@IBOutlet var fieldPassword0: UITextField!
	@IBOutlet var fieldPassword1: UITextField!
	@IBOutlet var fieldPassword2: UITextField!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Change Password"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDone))

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tableView.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidAppear(_ animated: Bool) {

		super.viewDidAppear(animated)
		fieldPassword0.becomeFirstResponder()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)
		dismissKeyboard()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func dismissKeyboard() {

		view.endEditing(true)
	}

	// MARK: - Backend actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func checkPassword() {

		ProgressHUD.show(nil, interaction: false)

		if let firuser = Auth.auth().currentUser {
			if let email = firuser.email {
				if let password = fieldPassword0.text {
					let credential = EmailAuthProvider.credential(withEmail: email, password: password)
					firuser.reauthenticate(with: credential) { authResult, error in
						if (error == nil) {
							self.updatePassword()
						} else {
							ProgressHUD.showError(error!.localizedDescription)
						}
					}
				} else { ProgressHUD.showError("Check password error.") }
			} else { ProgressHUD.showError("Check password error.") }
		} else { ProgressHUD.showError("Check password error.") }
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updatePassword() {

		if let firuser = Auth.auth().currentUser {
			if let password = fieldPassword1.text {
				firuser.updatePassword(to: password) { error in
					if (error == nil) {
						ProgressHUD.showSuccess("Password changed.")
						self.dismiss(animated: true)
					} else {
						ProgressHUD.showError(error!.localizedDescription)
					}
				}
			} else { ProgressHUD.showError("Update password error.") }
		} else { ProgressHUD.showError("Update password error.") }
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionDone() {

		let password0 = fieldPassword0.text ?? ""
		let password1 = fieldPassword1.text ?? ""
		let password2 = fieldPassword2.text ?? ""

		if (password0.count == 0)	{ ProgressHUD.showError("Current Password must be set.");	return	}
		if (password1.count == 0)	{ ProgressHUD.showError("New Password must be set.");		return	}
		if (password1 != password2)	{ ProgressHUD.showError("New Passwords must be the same.");	return	}

		checkPassword()
	}

	// MARK: - Table view data source
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in tableView: UITableView) -> Int {

		return 2
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		if (section == 0) { return 1 }
		if (section == 1) { return 2 }

		return 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if (indexPath.section == 0) && (indexPath.row == 0) { return cellPassword0	}
		if (indexPath.section == 1) && (indexPath.row == 0) { return cellPassword1	}
		if (indexPath.section == 1) && (indexPath.row == 1) { return cellPassword2	}

		return UITableViewCell()
	}

	// MARK: - Table view delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)
	}

	// MARK: - UITextField delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		if (textField == fieldPassword0) { fieldPassword1.becomeFirstResponder()	}
		if (textField == fieldPassword1) { fieldPassword2.becomeFirstResponder()	}
		if (textField == fieldPassword2) { actionDone()								}

		return true
	}
}
