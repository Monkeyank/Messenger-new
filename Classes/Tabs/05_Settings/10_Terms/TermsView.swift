class TermsView: UIViewController {

	@IBOutlet var webView: UIWebView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Terms of Service"
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		let path = Dir.application("terms.html")
		webView.loadRequest(URLRequest(url: URL(fileURLWithPath: path)))
	}
}
