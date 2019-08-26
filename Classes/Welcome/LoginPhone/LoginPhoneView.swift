@objc protocol LoginPhoneDelegate: class {

	func didLoginPhone()
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class LoginPhoneView: UIViewController, UITextFieldDelegate, CountriesDelegate, VerifyCodeDelegate {

	@IBOutlet weak var delegate: LoginPhoneDelegate?

	@IBOutlet var labelName: UILabel!
	@IBOutlet var labelCode: UILabel!
	@IBOutlet var fieldPhone: UITextField!

	private var buttonRight: UIBarButtonItem?

	private var verificationID = ""

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Phone Login"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))

		buttonRight = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(actionNext))

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false

		if let countries = NSArray(contentsOfFile: Dir.application("countries.plist")) {
			if let country = countries[Int(DEFAULT_COUNTRY)] as? [String: String] {
				labelName.text = country["name"]
				labelCode.text = country["dial_code"]
			}
		}
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
	@objc func actionCancel() {

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionCountries(_ sender: Any) {

		let countriesView = CountriesView()
		countriesView.delegate = self
		let navController = NavigationController(rootViewController: countriesView)
		present(navController, animated: true)
	}

	// MARK: - CountriesDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didSelectCountry(name: String, code: String) {

		labelName.text = name
		labelCode.text = code
		fieldPhone.becomeFirstResponder()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionNext() {

		dismissKeyboard()
		ProgressHUD.show(nil, interaction: false)

		let code = labelCode.text ?? ""
		let phone = fieldPhone.text ?? ""
		let number = "\(code)\(phone)"

		PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
			if (error == nil) {
				ProgressHUD.dismiss()

				let verifyCodeView = VerifyCodeView(countryCode: code, phoneNumber: phone)
				verifyCodeView.delegate = self
				let navController = NavigationController(rootViewController: verifyCodeView)
				self.present(navController, animated: true)

				self.verificationID = verificationID!
			} else {
				ProgressHUD.showError(error!.localizedDescription)
			}
		}
	}

	// MARK: - VerifyCodeDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didVerifyCode(code: String) {

		ProgressHUD.show(nil, interaction: false)

		let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
		FUser.signIn(credential: credential) { user, error in
			if (error == nil) {
				self.saveUserPhone()
				self.dismiss(animated: true) {
					self.delegate?.didLoginPhone()
				}
			} else {
				ProgressHUD.showError(error!.localizedDescription)
			}
		}
	}

	// MARK: - Save user methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func saveUserPhone() {

		let code = labelCode.text ?? ""
		let phone = fieldPhone.text ?? ""

		let user = FUser.currentUser()
		user[FUSER_PHONE] = "\(code)\(phone)"
		user.saveInBackground(block: { error in
			if (error != nil) {
				ProgressHUD.showError("Network error.")
			}
		})
	}

	// MARK: - UITextFieldDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		let text = (textField.text ?? "") as NSString
		let phone = text.replacingCharacters(in: range, with: string)
		navigationItem.rightBarButtonItem = (phone.count != 0) ? buttonRight : nil

		return true
	}
}
