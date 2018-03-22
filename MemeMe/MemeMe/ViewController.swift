//
//  ViewController.swift
//  MemeMe
//
//  Created by Perica on 20.03.18.
//  Copyright © 2018 Boris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: Properties / Outlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    // MARK: UI Actions
    
    @IBAction func share(_ sender: Any) {
        let memeImage = generateMemeImage()
        let activityController = UIActivityViewController.init(activityItems: [memeImage], applicationActivities: nil)

        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if (success && error == nil) {
                save()
                self.dismiss(animated: true, completion: nil)
                
                return
            }
            
            //log the error
            print("ERROR :: \(error.debugDescription)")
            
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = UIConstants.top
        bottomTextField.text = UIConstants.bottom
        memeImageView.image = nil
        shareButton.isEnabled = false
    }
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
       
        if sender.accessibilityLabel == UIConstants.photoLibraryButtonAccessibilityLabel {
            imagePickerController.sourceType = .photoLibrary
        } else {
            imagePickerController.sourceType = .camera
        }
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        setShareButtonAttributes()
        setToolbarItemsAttributes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: UI Logic Methods

    func setShareButtonAttributes() {
        shareButton.isEnabled = (memeImageView.image != nil)
    }
    
    func setTextFieldAttributes() {
        topTextField.delegate = self
        bottomTextField.delegate = self
    
        let textFieldAttributes: [String:Any] = createTextFieldAttributes()
        topTextField.defaultTextAttributes = textFieldAttributes
        bottomTextField.defaultTextAttributes = textFieldAttributes
        
        topTextField.text = UIConstants.top
        bottomTextField.text = UIConstants.bottom
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    
    func createTextFieldAttributes() -> [String:Any] {
        let textFieldAttributes: [String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: UIConstants.textFieldFontName, size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: UIConstants.strokeWidth,
        ]
        
        return textFieldAttributes
    }
    
    func setToolbarItemsAttributes() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        albumButton.accessibilityLabel = UIConstants.photoLibraryButtonAccessibilityLabel
    }
    
    fileprivate func changeVisibilityOfBars(hide: Bool) {
        navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func save() -> Meme {
        let meme = Meme(originalImage: memeImageView.image, memedImage: generateMemeImage())
        
        return meme
    }
    
    /**
     Generates a memed image by rendering an image of the complete view
     excl. NavigationBar and ToolBar
     
     - returns: generated Meme - UIImage
    */
    func generateMemeImage() -> UIImage {
        changeVisibilityOfBars(hide: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        changeVisibilityOfBars(hide: false)
        
        return memedImage
    }
    
    // Keyboard actions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // move view-frame up
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        if let userInfo = notification.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            
            return keyboardSize.height
        }
        
        return 0
    }
    
    // MARK: Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :		 Any]) {
        if let image = info[UIConstants.infoPropertyOriginalImage] as? UIImage{
            memeImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

}

