class GroupsCell: UITableViewCell {

	@IBOutlet var imageGroup: UIImageView!
	@IBOutlet var labelInitials: UILabel!
	@IBOutlet var labelName: UILabel!
	@IBOutlet var labelMembers: UILabel!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(dbgroup: DBGroup) {

		labelInitials.text = String(dbgroup.name.prefix(1))

		labelName.text = dbgroup.name

		let members = Convert.stringToArray(dbgroup.members)
		labelMembers.text = "\(members.count) members"
	}
}
