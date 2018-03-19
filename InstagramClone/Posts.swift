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
    var postId: String!
    var userId: String!
    var likes: Int!
    private var image: UIImage!
    
    init(userName: String, image: UIImage, caption: String){
        self.userName = userName
        self.image = image
        self.caption = caption
        self.userId = Auth.auth().currentUser!.uid
    }
    
    init(snapshot: DataSnapshot) {
        let json = JSON(snapshot.value)
        self.userName = json["userName"].stringValue
        self.imageURL = json["imageURL"].stringValue
        self.caption = json["caption"].stringValue
        self.postId = json["postId"].stringValue
        self.userId = json["userId"].stringValue
        self.likes = json["likes"].int
    }
    
    func save() {
        print(self.userName + " " + self.userId)
        let newPostRef = Database.database().reference().child("photoPosts").childByAutoId()
        let newPostKey = newPostRef.key
        self.postId = newPostKey
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.6) {
            let imageStorageRef = Storage.storage().reference().child("images")
            let newImageRef = imageStorageRef.child(newPostKey)
            
            newImageRef.putData(uploadData).observe(.success, handler:
                {(snapshot) in
                    print("upload complete!")
                    print(snapshot.metadata?.downloadURL()?.absoluteString)
                    self.imageURL = snapshot.metadata?.downloadURL()?.absoluteString
                    let newPostDic = [
                        "userId": self.userId,
                        "userName": self.userName,
                        "imageURL": self.imageURL,
                        "caption": self.caption,
                        "postId":newPostKey
                    ]
                    newPostRef.setValue(newPostDic)
            })
        }
    }
    
}
