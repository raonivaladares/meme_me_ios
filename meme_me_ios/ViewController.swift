import UIKit

class ViewController: UIViewController {
	@IBOutlet weak private var imageView: UIImageView!
	@IBOutlet weak private var cameraButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
	}

	@IBAction func pickAnImageActionHandler(_ sender: UIBarButtonItem) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .photoLibrary
		present(pickerController, animated: true, completion: nil)
	}
	
	@IBAction func takeAPictureActionHandler(_ sender: Any) {
		
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .camera
		present(pickerController, animated: true, completion: nil)
	}
}

extension ViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imageView.image = image
		}
		dismiss(animated: true, completion: nil)
	}
}

extension ViewController: UINavigationControllerDelegate {
	
}
