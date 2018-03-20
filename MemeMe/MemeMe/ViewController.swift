//
//  ViewController.swift
//  MemeMe
//
//  Created by Perica on 20.03.18.
//  Copyright © 2018 Boris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Constants
    
    struct UIConstants {
        static let top = "TOP"
        static let bottom = "BOTTOM"
        static let textFieldFontName = "HelveticaNeue-CondensedBlack"
        static let photoLibraryButtonAccessibilityLabel = "AlbumButton"
        static let strokeWidth = "4.0"
    }
    
    
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
    
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = UIConstants.top
        bottomTextField.text = UIConstants.bottom
        memeImageView.image = nil
    }
    
    @IBAction func share(_ sender: Any) {
        let memeImage = generateMemeImage()
        let activityController = UIActivityViewController.init(activityItems: [memeImage], applicationActivities: nil)
        
        self.present(activityController, animated: true, completion: nil)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setShareButtonAttributes()
        setTextFieldAttributes()
        setToolbarItemsAttributes()
    }
    
    // MARK: UI Logic Methods
    
    func setShareButtonAttributes() {
        shareButton.isEnabled = (memeImageView.image != nil)
    }
    
    func setTextFieldAttributes() {
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.text = UIConstants.top
        bottomTextField.text = UIConstants.bottom
        
        let textFieldAttributes: [String:Any] = createTextFieldAttributes()
        topTextField.defaultTextAttributes = textFieldAttributes
        bottomTextField.defaultTextAttributes = textFieldAttributes
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
    
    // MARK: Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :		 Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
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
}

