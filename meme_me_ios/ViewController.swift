import UIKit

class ViewController: UIViewController {
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var topTextField: UITextField!
	@IBOutlet private weak var bottomTextField: UITextField!
	@IBOutlet private weak var cameraButton: UIBarButtonItem!
	
	private let defaultTopText = "TOP"
	private let defaultBottomText = "BOTTOM"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		setupTextFields()
		
		
	}
	
	// MARK: - View life-cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}

	// MARK: - Action handlers
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
	
	// MARK: - Selectors
	@objc func keyboardWillShow(_ notification: Notification) {
		if bottomTextField.isFirstResponder {
			view.frame.origin.y = -getKeyboardHeight(notification)
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		if bottomTextField.isFirstResponder {
			view.frame.origin.y = 0
		}
	}
	
	// MARK: - Private methods
	private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	private func setupTextFields() {
		let memeTextAttributes:[String: Any] = [
			NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
			NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
			NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSAttributedStringKey.strokeWidth.rawValue: -3
		]
		
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.delegate = self
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.delegate = self
		
		topTextField.textAlignment = .center
		bottomTextField.textAlignment = .center
	}
}

// MARK: - Extensions
extension ViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imageView.image = image
		}
		dismiss(animated: true, completion: nil)
	}
}

extension ViewController: UINavigationControllerDelegate {}

extension ViewController: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let text = textField.text,
			text.contains(defaultTopText) || text.contains(defaultBottomText) {
				textField.text = nil
		}
		
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
}
