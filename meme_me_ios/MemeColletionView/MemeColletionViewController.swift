import UIKit

class MemeColletionViewController: UIViewController {
	@IBOutlet private weak var colletionView: UICollectionView!
	
	private var memes: [Meme]!
	
	// MARK: - View lify-cicle
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
extension MemeColletionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let meme = memes[indexPath.row]
		performSegue(withIdentifier: "collectionToDetailsSegue", sender: meme)
	}
}

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

extension MemeColletionViewController: UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//https://gist.github.com/makthrow/067ec222b81d6a1e2419
		let numberOfItemsPerRow = 3
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
			+ (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
		let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
		
		return CGSize(width: size, height: size)
	}
}
