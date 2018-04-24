import UIKit

class MemeDetailsViewController: UIViewController {
	
	@IBOutlet private weak var imageView: UIImageView!
	
	var meme: Meme!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.image = meme.memeImage
	}
}
