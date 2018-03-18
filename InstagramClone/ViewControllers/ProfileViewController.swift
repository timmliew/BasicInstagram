//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/17/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userId: UILabel!
    
    var name: String!
    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = self.name
        userId.text = self.id
    }
    

}
