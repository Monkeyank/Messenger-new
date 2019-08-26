@objc protocol VerifyCodeDelegate: class {

	func didVerifyCode(code: String)
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class VerifyCodeView: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var delegate: VerifyCodeDelegate?

	@IBOutlet private var labelHeader: UILabel!
	@IBOutlet private var fieldCode: UITextField!

	private var countryCode = ""
	private var phoneNumber = ""

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(countryCode countryCode_: String, phoneNumber phoneNumber_: String) {

		super.init(nibName: nil, bundle: nil)

		countryCode = countryCode_
		phoneNumber = phoneNumber_
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "SMS Verification"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false

		labelHeader.text = "Enter the verification code sent to\n\n\(countryCode) \(phoneNumber)"
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidAppear(_ animated: Bool) {

		super.viewDidAppear(animated)

		fieldCode.becomeFirstResponder()
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

	// MARK: - UITextFieldDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		let text = (textField.text ?? "") as NSString
		let code = text.replacingCharacters(in: range, with: string)

		if (code.count == 6) {
			dismissKeyboard()
			ProgressHUD.show(nil, interaction: false)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
				self.dismiss(animated: true) {
					self.delegate?.didVerifyCode(code: code)
				}
			}
		}

		return (code.count <= 6)
	}
}
