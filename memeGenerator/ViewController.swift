//
//  ViewController.swift
//  memeGenerator
//
//  Created by Angela Tuzson on 12/17/17.
//  Copyright © 2017 Andrew Tuzson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var btnSave: UIButton!
    
    // Style the text field attributes
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureText(textField: topTextField)
        configureText(textField: bottomTextField)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        activityButton.isEnabled = false
    }
    
    // Set up text attributes
    
    func configureText(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    // Shift keyboard functions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Initialize the Meme object
    
    func generateMemedImage() -> UIImage {
        UIView.animate(withDuration: 0.25, animations: { self.toolbar.alpha = 0 })
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIView.animate(withDuration: 0.25, animations: { self.toolbar.alpha = 1 })
        return memedImage
    }
    
    func save() {
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // Define image source and present VC
    
    func defineSourceType(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }

    // MARK: Actions
    
    @IBAction func didClickButtonSave(_ sender: UIButton) {
        self.save()
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        defineSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        defineSourceType(sourceType: .camera)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        activityButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
}


// MARK: UIImagePickerControllerDelgate Methods

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        activityButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate Methods

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if textField.tag == 2 {
            subscribeToKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.topTextField.resignFirstResponder()
        self.bottomTextField.resignFirstResponder()
        unsubscribeFromKeyboardNotifications()
        return true
    }
}








