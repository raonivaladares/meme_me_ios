import UIKit

class MemeTableViewController: UIViewController {
	@IBOutlet private weak var tableView: UITableView!
	
	private var memes: [Meme]!
	
	// MARK: - View lify-cicle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = 160
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		memes = MemeRepository.memes
		tableView.reloadData()
	}
	
	// MARK: - Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let viewController = segue.destination as? MemeDetailsViewController,
			 let meme = sender as? Meme {
			viewController.meme = meme
		}
	}
}

// MARK: - Extensions
extension MemeTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let meme = memes[indexPath.row]
		performSegue(withIdentifier: "tableToDetailsSegue", sender: meme)
	}
	
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
