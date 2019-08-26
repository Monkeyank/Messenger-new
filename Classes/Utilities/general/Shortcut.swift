class Shortcut: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func create() {

		if (UIApplication.shared.shortcutItems?.count == 0) {

			var items: [UIApplicationShortcutItem] = []

			if let item = createItem(type: "newchat", title: "New Chat", iconType: .compose, userInfo: nil)		{ items.append(item)	}
			if let item = createItem(type: "newgroup", title: "New Group", iconType: .add, userInfo: nil)		{ items.append(item)	}
			if let item = createItem(type: "shareapp", title: "Share Chat", iconType: .share, userInfo: nil)	{ items.append(item)	}

			UIApplication.shared.shortcutItems = items
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func update(userId: String) {

		var items: [UIApplicationShortcutItem] = []

		let predicate = NSPredicate(format: "objectId == %@", userId)
		let dbuser = DBUser.objects(with: predicate).firstObject() as! DBUser

		let objectId = dbuser.objectId
		let fullname = dbuser.fullname
		let userInfo = ["userId": objectId]

		if let item = createItem(type: "newchat", title: "New Chat", iconType: .compose, userInfo: nil)			{ items.append(item)	}
		if let item = createItem(type: "newgroup", title: "New Group", iconType: .add, userInfo: nil)			{ items.append(item)	}
		if let item = createItem(type: "recentuser", title: fullname, iconType: .contact, userInfo: userInfo)	{ items.append(item)	}
		if let item = createItem(type: "shareapp", title: "Share Chat", iconType: .share, userInfo: nil)		{ items.append(item)	}

		UIApplication.shared.shortcutItems = items
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(type: String, title: String, iconType: UIApplicationShortcutIcon.IconType, userInfo: [String: String]?) -> UIApplicationShortcutItem? {

		let icon = UIApplicationShortcutIcon(type: iconType)

		if let info = userInfo {
			return UIApplicationShortcutItem(type: type, localizedTitle: title, localizedSubtitle: nil, icon: icon, userInfo: info as [String: NSSecureCoding])
		} else {
			return UIApplicationShortcutItem(type: type, localizedTitle: title, localizedSubtitle: nil, icon: icon, userInfo: nil)
		}
	}
}
