import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
	private let initialTexts: [String]
	
	init(defaultTexts: String...) {
		initialTexts = defaultTexts
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if let text = textField.text,
			initialTexts.contains(text) {
			textField.text = nil
		}
		
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
}
