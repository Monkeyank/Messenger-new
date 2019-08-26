class VideoView: UIViewController {

	private var url: URL!
	private var controller: AVPlayerViewController?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	init(url url_: URL) {

		super.init(nibName: nil, bundle: nil)

		url = url_
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()

		let notification = NSNotification.Name.AVPlayerItemDidPlayToEndTime
		NotificationCenter.addObserver(target: self, selector: #selector(actionDone), name: notification.rawValue)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .default, options: .defaultToSpeaker)

		controller = AVPlayerViewController()
		controller?.player = AVPlayer(url: url)
		controller?.player?.play()

		if (controller != nil) {
			addChild(controller!)
			view.addSubview(controller!.view)
			controller!.view.frame = view.frame
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)

		NotificationCenter.removeObserver(target: self)
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionDone() {

		dismiss(animated: true)
	}
}
