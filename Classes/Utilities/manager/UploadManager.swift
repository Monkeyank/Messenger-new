class UploadManager: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func user(_ name: String, data: Data, completion: @escaping (_ error: Error?) -> Void) {

		upload(data: data, dir: "user", name: name, ext: "jpg", completion: completion)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func image(_ name: String, data: Data, completion: @escaping (_ error: Error?) -> Void) {

		upload(data: data, dir: "media", name: name, ext: "jpg", completion: completion)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func video(_ name: String, data: Data, completion: @escaping (_ error: Error?) -> Void) {

		upload(data: data, dir: "media", name: name, ext: "mp4", completion: completion)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func audio(_ name: String, data: Data, completion: @escaping (_ error: Error?) -> Void) {

		upload(data: data, dir: "media", name: name, ext: "m4a", completion: completion)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private class func upload(data: Data, dir: String, name: String, ext: String, completion: @escaping (_ error: Error?) -> Void) {

		let path = "\(dir)/\(name).\(ext)"

		let reference = Storage.storage().reference(withPath: path)
		let task = reference.putData(data, metadata: nil, completion: nil)

		task.observe(StorageTaskStatus.success, handler: { snapshot in
			task.removeAllObservers()
			completion(nil)
		})

		task.observe(StorageTaskStatus.failure, handler: { snapshot in
			task.removeAllObservers()
			completion(NSError.description("Upload failed.", code: 100))
		})
	}
}
