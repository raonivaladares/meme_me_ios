import UIKit

class MemeGeneratorViewController: UIViewController {
	@IBOutlet private weak var shareButton: UIBarButtonItem!
	@IBOutlet private weak var cancelButton: UIBarButtonItem!
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var topTextField: UITextField!
	@IBOutlet private weak var bottomTextField: UITextField!
	@IBOutlet private weak var cameraButton: UIBarButtonItem!
	
	@IBOutlet weak var toolBar: UIToolbar!
	private let defaultTopText = "TOP"
	private let defaultBottomText = "BOTTOM"
	private var memeTextFieldDelegate: MemeTextDelegate!
	
	enum MemeImageState {
		case selecting
		case selected
	}
	
	var memeImageState: MemeImageState = .selecting {
		didSet {
			switch memeImageState {
			case .selecting: prepareForSeletion()
			case .selected: shareButton.isEnabled = true
			}
		}
	}
	
	// MARK: - View life-cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		memeTextFieldDelegate = MemeTextDelegate(defaultTexts: defaultTopText, defaultBottomText)
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		setupTextFields()
		prepareForSeletion()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}

	// MARK: - Action handlers
	@IBAction func shareActionHandler(_ sender: UIBarButtonItem) {
		guard let image = imageView.image else {
			presentAlertWithError()
			return
		}
		
		let imageToShare = generateMemedImage()

		let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
		activityViewController.completionWithItemsHandler =  { [weak self] activity, success, items, error in
			guard let this = self else { return }
			
			if success {
				let memeModel = this.gereneteMemeModel(originalImage: image, memeImage: imageToShare)
				MemeRepository.save(model: memeModel)
				this.navigationController?.popViewController(animated: true)
			}
			
			activityViewController.completionWithItemsHandler = nil
		}
		
		activityViewController.popoverPresentationController?.sourceView = view
		present(activityViewController, animated: true, completion: nil)
	}
	
	@IBAction func cancelActionHandler(_ sender: UIBarButtonItem) {
		memeImageState = .selecting
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func pickAnImageActionHandler(_ sender: UIBarButtonItem) {
		let pickerController = generatePickerController(sourceType: .photoLibrary)
		present(pickerController, animated: true, completion: nil)
	}
	
	@IBAction func takeAPictureActionHandler(_ sender: Any) {
		let pickerController = generatePickerController(sourceType: .camera)
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
		func setupTextField(textField: UITextField, defaultTextAttributes: [String: Any]) {
			textField.defaultTextAttributes = defaultTextAttributes
			textField.textAlignment = .center
			textField.delegate = memeTextFieldDelegate
		}
		
		let memeTextAttributes: [String: Any] = [
			NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
			NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
			NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSAttributedStringKey.strokeWidth.rawValue: -3
		]
		
		setupTextField(textField: topTextField, defaultTextAttributes: memeTextAttributes)
		setupTextField(textField: bottomTextField, defaultTextAttributes: memeTextAttributes)
	}
	
	private func prepareForSeletion() {
		imageView.image = nil
		
		topTextField.text = defaultTopText
		topTextField.resignFirstResponder()
		bottomTextField.text = defaultBottomText
		bottomTextField.resignFirstResponder()
		shareButton.isEnabled = false
	}
	
	func generateMemedImage() -> UIImage {
		UIGraphicsBeginImageContext(view.frame.size)
		
		toolBar.isHidden = true
		view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
		toolBar.isHidden = false
		
		let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return memedImage
	}
	
	private func gereneteMemeModel(originalImage: UIImage, memeImage: UIImage) -> Meme {
		let topText = topTextField.text ?? ""
		let bottomText = bottomTextField.text ?? ""
		return Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memeImage: memeImage)
	}
	
	private func presentAlertWithError() {
		let alert = UIAlertController(title: "Ops...", message: "Something is wrong!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		
		present(alert, animated: true, completion: nil)
	}
	
	private func generatePickerController(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = sourceType
		return pickerController
	}
}

// MARK: - Extensions
extension MemeGeneratorViewController: UINavigationControllerDelegate {}

extension MemeGeneratorViewController: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imageView.image = image
			memeImageState = .selected
		}
		dismiss(animated: true, completion: nil)
	}
}
