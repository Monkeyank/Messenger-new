class Cryptor: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func encrypt(text: String, chatId: String) -> String? {

		if let dataDecrypted = text.data(using: .utf8) {
			if let dataEncrypted = encrypt(data: dataDecrypted, chatId: chatId) {
				return dataEncrypted.base64EncodedString(options: [])
			}
		}
		return nil
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func decrypt(text: String, chatId: String) -> String? {

		if let dataEncrypted = Data(base64Encoded: text, options: []) {
			if let dataDecrypted = decrypt(data: dataEncrypted, chatId: chatId) {
				return String(data: dataDecrypted, encoding: .utf8)
			}
		}
		return nil
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func encrypt(data: Data, chatId: String) -> Data? {

		let password = Password.get(chatId: chatId)
		return try? RNEncryptor.encryptData(data, with: kRNCryptorAES256Settings, password: password)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func decrypt(data: Data, chatId: String) -> Data? {

		let password = Password.get(chatId: chatId)
		return try? RNDecryptor.decryptData(data, withPassword: password)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func encrypt(path: String, chatId: String) {

		do {
			let dataDecrypted = try Data(contentsOf: URL(fileURLWithPath: path))
			if let dataEncrypted = encrypt(data: dataDecrypted, chatId: chatId) {
				do {
					try dataEncrypted.write(to: URL(fileURLWithPath: path), options: .atomic)
				} catch { print("Cryptor encryptFile error.") }
			}
		} catch { print("Cryptor encryptFile error.") }
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func decrypt(path: String, chatId: String) {

		do {
			let dataEncrypted = try Data(contentsOf: URL(fileURLWithPath: path))
			if let dataDecrypted = decrypt(data: dataEncrypted, chatId: chatId) {
				do {
					try dataDecrypted.write(to: URL(fileURLWithPath: path), options: .atomic)
				} catch { print("Cryptor decryptFile error.") }
			}
		} catch { print("Cryptor decryptFile error.") }
	}
}
