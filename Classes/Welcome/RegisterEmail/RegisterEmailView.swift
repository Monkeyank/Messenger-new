@objc protocol RegisterEmailDelegate: class {

	func didRegisterUser()
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class RegisterEmailView: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var delegate: RegisterEmailDelegate?

	@IBOutlet var fieldEmail: UITextField!
	@IBOutlet var fieldPassword: UITextField!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false
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

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRegister(_ sender: Any) {

		let email = (fieldEmail.text ?? "").lowercased()
		let password = fieldPassword.text ?? ""

		if (email.count == 0)		{ ProgressHUD.showError("Please enter your email."); return 	}
		if (password.count == 0)	{ ProgressHUD.showError("Please enter your password."); return 	}

		ProgressHUD.show(nil, interaction: false)

		FUser.createUser(email: email, password: password) { user, error in
			if (error == nil) {
				self.dismiss(animated: true) {
					self.delegate?.didRegisterUser()
				}
			} else {
				ProgressHUD.showError(error!.localizedDescription)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionDismiss(_ sender: Any) {

		dismiss(animated: true)
	}

	// MARK: - UITextField delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		if (textField == fieldEmail) {
			fieldPassword.becomeFirstResponder()
		}
		if (textField == fieldPassword) {
			actionRegister(0)
		}
		return true
	}
}
