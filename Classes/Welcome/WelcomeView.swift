class WelcomeView: UIViewController, LoginPhoneDelegate, LoginEmailDelegate, RegisterEmailDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
	}

	// MARK: - Phone login methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionLoginPhone(_ sender: Any) {

		let loginPhoneView = LoginPhoneView()
		loginPhoneView.delegate = self
		let navController = NavigationController(rootViewController: loginPhoneView)
		present(navController, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didLoginPhone() {

		dismiss(animated: true) {
			Userx.loggedIn(loginMethod: LOGIN_PHONE)
		}
	}

	// MARK: - Email login methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionLoginEmail(_ sender: Any) {

		let loginEmailView = LoginEmailView()
		loginEmailView.delegate = self
		present(loginEmailView, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didLoginEmail() {

		dismiss(animated: true) {
			Userx.loggedIn(loginMethod: LOGIN_EMAIL)
		}
	}

	// MARK: - Email register methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRegisterEmail(_ sender: Any) {

		let registerEmailView = RegisterEmailView()
		registerEmailView.delegate = self
		present(registerEmailView, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didRegisterUser() {

		dismiss(animated: true) {
			Userx.loggedIn(loginMethod: LOGIN_EMAIL)
		}
	}
}
