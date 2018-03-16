//
//  Cell.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/15/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Cell: UITableViewCell {
    
    @IBOutlet var postedImageView: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var message: UILabel!
    
    var post: Posts! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI(){
        self.message.text = post.caption
        self.username.text = post.userName
        
        if let imageURL = post.imageURL {
            let downloadTask = Storage.storage().reference(forURL: imageURL).getData(maxSize: 2 * 1024 * 1024) { data, error in
                if let error = error {
                    print("There is an error downloading image! : \(error)")
                } else {
                    print("Image downloaded successfully!")
                    DispatchQueue.main.async {
                        self.postedImageView.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
}
