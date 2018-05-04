import UIKit

class MemeDetailsViewController: UIViewController {
	@IBOutlet private weak var imageView: UIImageView!
	
	var meme: Meme!
	
	// MARK: - View lify-cicle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = meme.memeImage
	}
}
