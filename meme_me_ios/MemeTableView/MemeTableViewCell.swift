import UIKit

class MemeTableViewCell: UITableViewCell {
	@IBOutlet private weak var memeImage: UIImageView!
	@IBOutlet private weak var memeDescription: UILabel!
	
	// MARK: - Public methods
	func populate(image: UIImage, description: String) {
		memeImage.image = image
		memeDescription.text = description
	}
}

// MARK: - Extensions
extension MemeTableViewCell: ReusableView {}
