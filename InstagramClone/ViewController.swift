//
//  ViewController.swift
//  SimpleInstagram
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    private var ref: DatabaseReference!
    private var storage: Storage!
    
    private let textFieldDelegate = TextFieldDelegate()
    private var profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userTextField.delegate = self.textFieldDelegate
        messageTextField.delegate = self.textFieldDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Pick image from library
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            profile.photoImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        if userTextField.text != "" && messageTextField.text != "" && imageView.image != nil {
            let name = (userTextField.text as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            let newPost = Posts(userName: name, image: imageView.image!, caption: messageTextField.text!)
            newPost.save()
            self.dismiss(animated: true, completion: nil)
        }
    }

}

