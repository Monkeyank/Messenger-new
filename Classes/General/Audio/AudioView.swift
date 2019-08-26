@objc protocol AudioDelegate: class {

	func didRecordAudio(path: String)
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class AudioView: UIViewController, AVAudioPlayerDelegate {

	@IBOutlet weak var delegate: AudioDelegate?

	@IBOutlet var labelTimer: UILabel!
	@IBOutlet var buttonRecord: UIButton!
	@IBOutlet var buttonStop: UIButton!
	@IBOutlet var buttonDelete: UIButton!
	@IBOutlet var buttonPlay: UIButton!
	@IBOutlet var buttonSend: UIButton!

	private var isPlaying = false
	private var isRecorded = false
	private var isRecording = false

	private var timer: Timer?
	private var dateTimer: Date?

	private var audioPlayer: AVAudioPlayer?
	private var audioRecorder: AVAudioRecorder?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Audio"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))

		updateButtonDetails()
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		actionStop(0)

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRecord(_ sender: Any) {

		audioRecorderStart()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionStop(_ sender: Any) {

		if (isPlaying)		{ audioPlayerStop()		}
		if (isRecording)	{ audioRecorderStop()	}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionDelete(_ sender: Any) {

		isRecorded = false
		updateButtonDetails()

		timerReset()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionPlay(_ sender: Any) {

		audioPlayerStart()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionSend(_ sender: Any) {

		dismiss(animated: true)

		if let path = audioRecorder?.url.path {
			delegate?.didRecordAudio(path: path)
		}
	}

	// MARK: - Audio recorder methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func audioRecorderStart() {

		isRecording = true
		updateButtonDetails()

		timerStart()

		try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)

		let settings = [AVFormatIDKey: kAudioFormatMPEG4AAC, AVSampleRateKey: 44100, AVNumberOfChannelsKey: 2]
		audioRecorder = try? AVAudioRecorder(url: URL(fileURLWithPath: File.temp(ext: "m4a")), settings: settings)
		audioRecorder?.prepareToRecord()
		audioRecorder?.record()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func audioRecorderStop() {

		isRecording = false
		isRecorded = true
		updateButtonDetails()

		timerStop()

		audioRecorder?.stop()
	}

	// MARK: - Audio player methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func audioPlayerStart() {

		isPlaying = true
		updateButtonDetails()

		timerStart()

		try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .default, options: .defaultToSpeaker)

		if let url = audioRecorder?.url {
			audioPlayer = try? AVAudioPlayer(contentsOf: url)
			audioPlayer?.delegate = self
			audioPlayer?.prepareToPlay()
			audioPlayer?.play()
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

		isPlaying = false
		updateButtonDetails()

		timerStop()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func audioPlayerStop() {

		isPlaying = false
		updateButtonDetails()

		timerStop()

		audioPlayer?.stop()
	}

	// MARK: - Timer methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func timerStart() {

		dateTimer = Date()

		timer = Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func timerUpdate() {

		if (dateTimer != nil) {
			let interval = Date().timeIntervalSince(dateTimer!)
			let millisec = Int(interval * 100) % 100
			let seconds = Int(interval) % 60
			let minutes = Int(interval) / 60
			labelTimer.text = String(format: "%02d:%02d:%02d", minutes, seconds, millisec)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func timerStop() {

		timer?.invalidate()
		timer = nil
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func timerReset() {

		labelTimer.text = "00:00:00"
	}

	// MARK: - Helper methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateButtonDetails() {

		buttonRecord.isHidden	= isRecorded
		buttonStop.isHidden		= (isPlaying == false) && (isRecording == false)
		buttonDelete.isHidden	= (isPlaying == true) || (isRecorded == false)
		buttonPlay.isHidden		= (isPlaying == true) || (isRecorded == false)
		buttonSend.isHidden		= (isPlaying == true) || (isRecorded == false)
	}
}
