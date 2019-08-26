class PrivacyView: UIViewController {

	@IBOutlet var webView: UIWebView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Privacy Policy"
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		let path = Dir.application("privacy.html")
		webView.loadRequest(URLRequest(url: URL(fileURLWithPath: path)))
	}
}
