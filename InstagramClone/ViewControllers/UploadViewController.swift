//
//  ViewController.swift
//  SimpleInstagram
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    private let textDelegate = TextFieldDelegate()
    private var profileUserName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.messageTextField.delegate = textDelegate
        self.userTextField.delegate = textDelegate
        
        if ( FBSDKAccessToken.current() != nil ) {
            // User is logged in, use 'accessToken' here.
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    /* Update player profile */
                    print(result)
                    
                    guard let resultDict = result as? [String : AnyObject] else {
                        print("no result")
                        return
                    }
                    
                    guard let first_name = resultDict["first_name"] as? String else {
                        print("no first name found")
                        return
                    }
                    
                    guard let last_name = resultDict["last_name"] as? String else {
                        print("no first name found")
                        return
                    }
                    
                    self.profileUserName = "\(first_name) \(last_name)"
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Pick image from library
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
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
        if messageTextField.text != "" && imageView.image != nil {
//            let name = (userTextField.text as! String).trimmingCharacters(in: CharacterSet.whitespaces)
            let newPost = Posts(userName: self.profileUserName, image: imageView.image!, caption: messageTextField.text!)
            newPost.save()
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let home = storyboard.instantiateViewController(withIdentifier: "TarBarController") as! UITabBarController
            self.present(home, animated: true, completion: nil)
        }
    }

}

