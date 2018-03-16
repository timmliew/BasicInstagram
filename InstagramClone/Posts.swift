//
//  Posts.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/16/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class Posts {
    var userName: String!
    var caption: String!
    var imageURL: String!
    private var image: UIImage!
    
    init(userName: String, image: UIImage, caption: String){
        self.userName = userName
        self.image = image
        self.caption = caption
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.userName = json["userName"].stringValue
        self.imageURL = json["imageURL"].stringValue
        self.caption = json["caption"].stringValue
    }
    
    func save() {
        let newPostRef = Database.database().reference().child("photoPosts").childByAutoId()
        let newPostKey = newPostRef.key
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.6) {
            let imageStorageRef = Storage.storage().reference().child("images")
            let newImageRef = imageStorageRef.child(newPostKey)
            
            newImageRef.putData(uploadData).observe(.success, handler:
                {(snapshot) in
                    print("upload complete!")
                    print(snapshot.metadata?.downloadURL()?.absoluteString)
                    self.imageURL = snapshot.metadata?.downloadURL()?.absoluteString
                    let newPostDic = [
                        "userName": self.userName,
                        "imageURL": self.imageURL,
                        "caption": self.caption
                    ]
                    newPostRef.setValue(newPostDic)
            })
        }
    }
    
}
