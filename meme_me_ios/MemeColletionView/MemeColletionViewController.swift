import UIKit

class MemeColletionViewController: UIViewController {
	
	@IBOutlet private weak var colletionView: UICollectionView!
	
	private var memes: [Meme]!
	
//	// MARK: - View lify-cicle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		memes = MemeRepository.memes
		colletionView.reloadData()
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
extension MemeColletionViewController: UICollectionViewDelegate {}

extension MemeColletionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = colletionView.dequeueReusableCell(withReuseIdentifier: MemeColletionViewCell.reuseIdentifier, for: indexPath) as! MemeColletionViewCell
				let meme = memes[indexPath.row]
		
				cell.populate(image: meme.memeImage)
		
				return cell
	}
}
