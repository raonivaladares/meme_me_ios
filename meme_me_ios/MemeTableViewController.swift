import UIKit

class MemeTableViewController: UIViewController {
	@IBOutlet private weak var tableView: UITableView!
	
	private var memes: [Meme]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = 160
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		memes = MemeRepository.memes
		tableView.reloadData()
	}
	
}

extension MemeTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableViewCell.reuseIdentifier, for: indexPath) as! MemeTableViewCell
		let meme = memes[indexPath.row]
		let text = unifyMemeTexts(topText: meme.topText, bottomText: meme.bottomText)
		
		cell.populate(image: meme.memeImage, description: text)
		
		return cell
	}
	
	private func unifyMemeTexts(topText: String, bottomText: String) -> String {
		var text = ""
		
		text.append(topText)
		text.append(" ")
		text.append(bottomText)
		
		return text
	}
}

extension MemeTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}
}

class MemeTableViewCell: UITableViewCell {

	@IBOutlet private weak var memeImage: UIImageView!
	@IBOutlet private weak var memeDescription: UILabel!
	
	func populate(image: UIImage, description: String) {
		memeImage.image = image
		memeDescription.text = description
	}
}

extension MemeTableViewCell: ReusableView {}

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}
