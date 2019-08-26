class RelayManager: NSObject {

	private var timer: Timer?
	private var inProgress = false
	private var dbmessages: RLMResults = DBMessage.objects(with: NSPredicate(value: false))

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: RelayManager = {
		let instance = RelayManager()
		return instance
	} ()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override init() {

		super.init()

		timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(relayMessages), userInfo: nil, repeats: true)

		let predicate = NSPredicate(format: "status == %@", TEXT_QUEUED)
		dbmessages = DBMessage.objects(with: predicate).sortedResults(usingKeyPath: FMESSAGE_CREATEDAT, ascending: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func relayMessages() {

		if (FUser.currentId() != "") {
			if (Connectivity.isReachable()) {
				if (inProgress == false) {
					relayNextMessage()
				}
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func relayNextMessage() {

		if let dbmessage = dbmessages.firstObject() as? DBMessage {
			inProgress = true
			MessageRelay.send(dbmessage: dbmessage) { error in
				if (error == nil) {
					dbmessage.updateItem(status: TEXT_SENT)
				}
				self.inProgress = false
			}
		}
	}
}
