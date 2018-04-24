import UIKit

class MemeColletionViewCell: UICollectionViewCell {
	@IBOutlet private weak var memeImageView: UIImageView!
	
	// MARK: - Public methods
	func populate(image: UIImage) {
		memeImageView.image = image
	}
}

// MARK: - Extensions
extension MemeColletionViewCell: ReusableView {}
